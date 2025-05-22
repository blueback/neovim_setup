-- vi: foldmethod=marker

-- Debug logging function
-- {{{
local disable_debugging = true;
local function debug_log(msg, data)
  if disable_debugging then
    return
  end
  -- Create a debug buffer if it doesn't exist
  local debug_buf = vim.fn.bufnr('debug-folds')
  if debug_buf == -1 then
    debug_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(debug_buf, 'debug-folds')
  end

  -- Append message to debug buffer
  local log_msg = string.format("[%s] %s", os.date("%H:%M:%S"), msg)
  if data then
    log_msg = log_msg .. ": " .. vim.inspect(data)
  end
  -- vim.api.nvim_buf_set_lines(debug_buf, -1, -1, false, { log_msg })
  local replacement_strings = {}
  for i in string.gmatch(log_msg, '([^' .. '\n|;' .. ']+)') do
    table.insert(replacement_strings, i)
  end
  vim.api.nvim_buf_set_lines(debug_buf, -1, -1, false, replacement_strings)
end
-- }}}

-- Function to visualize tree structure
-- {{{
local function tree_to_string(node, prefix)
  prefix = prefix or ""
  local result = prefix .. "Node(start=" .. node.start_line .. ", data=" .. tostring(node.data) .. ");"
  for _, child in ipairs(node.children) do
    result = result .. tree_to_string(child, prefix .. "  ")
  end
  return result
end
-- }}}

-- Node structure for both trees
-- {{{
local function create_node(start_line)
  debug_log("Creating node at line", start_line)
  return {
    start_line = start_line,
    children = {},
    -- Tree1: is_closed
    -- Tree2: end_line
    data = nil
  }
end
-- }}}

-- Function to build tree structure from buffer
-- {{{
local function build_tree(get_node_data)
  local stack = {}
  local root = create_node(0) -- Dummy root
  stack[0] = root
  local depth = 0
  local open_marker = '{{{'
  local close_marker = '}}}'

  debug_log("Starting tree build")
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for i, line in ipairs(lines) do
    if line:match(open_marker) then
      -- {{{
      depth = depth + 1
      debug_log("Found open marker at line", i)
      local node = create_node(i)
      node.data = get_node_data(i)
      debug_log("Node data", node.data)
      table.insert(stack[depth - 1].children, node)
      stack[depth] = node
      -- }}}
    elseif line:match(close_marker) then
      -- {{{
      debug_log("Found close marker at line", i)
      if stack[depth] then
        stack[depth].end_line = i
        debug_log("Setting end_line for depth", { depth = depth, line = i })
      end
      depth = depth - 1
      -- }}}
    end
  end

  debug_log("Tree structure:", ";" .. tree_to_string(root))
  return root
end
-- }}}


return function(options)
  -- {{{
  if vim.wo.foldmethod ~= 'marker' then
    -- {{{
    -- Format the buffer
    debug_log("Performing buffer format")
    vim.lsp.buf.format(options)
    return
    -- }}}
  end

  if vim.wo.foldmarker ~= '{{{,}}}' then
    -- {{{
    -- Format the buffer
    debug_log("Performing buffer format")
    vim.lsp.buf.format(options)
    return
    -- }}}
  end

  debug_log("Starting format_preserve_folds")

  -- Save the view
  local saved_view = vim.fn.winsaveview()

  -- Build first tree with fold states
  debug_log("Building tree1 (fold states)")
  local tree1 = build_tree(function(line_num)
    -- {{{
    local closed_line_num = vim.fn.foldclosed(line_num + 1)
    local is_closed = false
    if closed_line_num > -1 then
      if line_num == closed_line_num then
        is_closed = true
      end
    end
    debug_log("Checking fold state at line", {
      line = line_num,
      closed_line_num = closed_line_num,
      closed = is_closed
    })

    -- opening the fold if closed to get the correct fold state of nested folds
    if is_closed then
      debug_log("Opening fold at line", line_num)
      vim.cmd(string.format('%dfoldopen', line_num))
    end
    return is_closed
    -- }}}
  end)

  debug_log("Tree1 structure:", ";" .. tree_to_string(tree1))

  -- Format the buffer
  debug_log("Performing buffer format")
  vim.lsp.buf.format(options)

  -- Reload fold markers
  vim.cmd('normal! zx')
  debug_log("Reloaded fold markers")

  -- Build second tree with new line numbers
  debug_log("Building tree2 (new line numbers)")
  local tree2 = build_tree(function(line_num)
    debug_log("Recording new line number", line_num)
    return line_num -- store the new line number
  end)

  debug_log("Tree2 structure:", ";" .. tree_to_string(tree2))

  -- First open all the folds
  vim.cmd('normal! zR')

  -- Function to restore fold states by traversing both trees simultaneously
  local function restore_folds(node1, node2)
    -- {{{
    if #node1.children ~= #node2.children then
      -- Trees are not isomorphic, something went wrong
      -- {{{
      debug_log("Tree mismatch!", {
        node1_children = #node1.children,
        node2_children = #node2.children
      })
      return false
      -- }}}
    end

    for i = 1, #node1.children do
      -- {{{
      local child1 = node1.children[i]
      local child2 = node2.children[i]

      debug_log("Processing fold", {
        original_line = child1.start_line,
        new_line = child2.data,
        was_closed = child1.data
      })

      -- Recursively process children
      restore_folds(child1, child2)

      -- Restore fold state
      if child1.data then -- if fold was closed
        debug_log("Closing fold at line", child2.data)
        vim.cmd(string.format('%dfoldclose', child2.data))
      else
        -- No need to open as we are opening all at the beginning
        -- debug_log("Opening fold at line", child2.data)
        -- vim.cmd(string.format('%dfoldopen', child2.data))
      end
      -- }}}
    end

    return true
    -- }}}
  end

  -- Start restoration from the root
  debug_log("Starting fold restoration")
  local success = restore_folds(tree1, tree2)
  debug_log("Fold restoration complete", { success = success })

  if not success then
    vim.notify("Failed to restore folds: trees are not isomorphic", vim.log.levels.ERROR)
  end

  -- restore the view
  vim.fn.winrestview(saved_view)

  if disable_debugging then
    return
  end

  -- Open debug buffer in a split
  vim.cmd('vsplit')
  vim.cmd('buffer debug-folds')
  -- }}}
end
