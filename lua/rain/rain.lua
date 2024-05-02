local Rain = {}

-- List to store raindrops
Rain.raindropList = {}
Rain.spawnTimerList = {}

-- Default raindrop configuration
local defaultConfig = {
  character = ".",
  speed = 20,
  color = "lightblue",
  blend = 100
}

-- Function to move a raindrop down
local function moveRaindrop(raindrop, speed)
  local timer = vim.loop.new_timer()
  local newRaindrop = { name = raindrop, timer = timer }
  table.insert(Rain.raindropList, newRaindrop)

  local movePeriod = 1000 / (speed or defaultConfig.speed)
  vim.loop.timer_start(timer, 0, movePeriod, vim.schedule_wrap(function()
    if vim.api.nvim_win_is_valid(raindrop) then
      local config = vim.api.nvim_win_get_config(raindrop)
      local col, row = config["col"][false], config["row"][false]

      -- Update row and column to move the raindrop down and to the right
      config["row"] = row + 1
      config["col"] = col + 1

      -- Move the raindrop to the new position
      vim.api.nvim_win_set_config(raindrop, config)

      -- Check if the raindrop has reached the bottom or right edge of the screen
      if row >= vim.api.nvim_get_option("lines") or col >= vim.api.nvim_get_option("columns") then
        -- Reposition the raindrop at the top of the screen at a random column
        config["row"] = 0
        config["col"] = math.random(1, vim.api.nvim_get_option("columns"))
        vim.api.nvim_win_set_config(raindrop, config)
      end
    end
  end))
end

-- Function to spawn a new raindrop
Rain.spawn = function(character, speed, color)
  -- Determine the number of raindrops to spawn
  local numRaindrops = math.random(2, 10)

  for i = 1, numRaindrops do
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, 1, true, { character or defaultConfig.character })

    local raindrop = vim.api.nvim_open_win(buf, false, {
      relative = 'cursor',
      style = 'minimal',
      row = 1,
      col = math.random(1, vim.api.nvim_get_option("columns")),
      width = 1,
      height = 1
    })

    vim.cmd("hi Raindrop" ..
      raindrop .. " guifg=" .. (color or defaultConfig.color) .. " guibg=none blend=" .. defaultConfig.blend)
    vim.api.nvim_win_set_option(raindrop, 'winhighlight', 'Normal:Raindrop' .. raindrop)

    -- Start moving the raindrop after a random delay
    vim.loop.new_timer():start(math.random(0, 3000), 0, vim.schedule_wrap(function()
      moveRaindrop(raindrop, speed)
    end))
  end

  -- Spawn new raindrops at random intervals
  local spawnTimer = vim.loop.new_timer()
  table.insert(Rain.spawnTimerList, spawnTimer)
  spawnTimer:start(math.random(1000, 8000), 0, vim.schedule_wrap(function()
    Rain.spawn(character, speed, color)
  end))
end

-- Function to remove the last raindrop
Rain.removeLastRaindrop = function()
  local lastRaindrop = Rain.raindropList[#Rain.raindropList]

  if not lastRaindrop then
    vim.notify("No raindrop to remove!")
    return
  end

  local raindrop = lastRaindrop['name']
  local timer = lastRaindrop['timer']
  table.remove(Rain.raindropList, #Rain.raindropList)
  timer:stop()

  vim.api.nvim_win_close(raindrop, true)
end

-- Function to remove all raindrops
Rain.removeAllRaindrops = function()
  if #Rain.raindropList <= 0 then
    vim.notify("No raindrop to remove!")
    return
  end

  while (#Rain.raindropList > 0) do
    Rain.removeLastRaindrop()
  end
end

-- Function to set up raindrop configurations
Rain.setup = function(opts)
  defaultConfig = vim.tbl_deep_extend('force', defaultConfig, opts or {})
  vim.cmd("command! RainOn lua require('rain/rain').start()")
  vim.cmd("command! RainOff lua require('rain/rain').stop()")
end

Rain.start = function()
  if #Rain.raindropList == 0 then
    Rain.spawn()
  end
end

Rain.stop = function()
  -- Stop all spawn timers
  for _, timer in ipairs(Rain.spawnTimerList) do
    timer:stop()
  end
  Rain.spawnTimerList = {}

  for _, raindrop in ipairs(Rain.raindropList) do
    raindrop.timer:stop()
    vim.api.nvim_win_close(raindrop.name, true)
  end
  Rain.raindropList = {}
end

return Rain
