function MakeConfigTable(ConfigPath)
    local Config = {}
    local Section, Key, Value
  
    for l in io.lines(ConfigPath) do
    -- Basically we are going to read every line
    -- if it starts with a Section or a Key
    -- we will Store them into the table
  
      if l:match('^[[]') ~= nil then
      -- Extract the Section Name
      Section = l:match('^[[](.+)[]]$')
  
      -- Create a New Table for each Section
      Config[Section] = {}
      end
  
      if l:match('(.+)=') ~= nil then
        -- Extract Key and Value, using = as a Seperator
        Key, Value = l:match('(.+)=(.+)')
  
        -- Check if the Value is a Number, and Explicitly Convert it to an integer
        if tonumber(Value) ~= nil then
          Value = tonumber(Value)
        end
        
        -- Add Each Key and Value into its Section Table
        Config[Section][Key] = Value
      end
  
    end -- Lines Loop End
  
    return Config
  end