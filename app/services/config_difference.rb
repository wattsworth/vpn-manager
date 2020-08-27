module ConfigDifference
  def new_configurations?(config, config_file)
    # if the config file doesn't exist this represents a new configuration
    return false unless File.file?(config_file)
    # load the current configuration and ignore comments
    current_config = ""
    File.open(config_file, "r") do |file|
      file.each do |line|
        unless line.starts_with?('#')
          current_config+=line
        end
      end
    end
    # remove comments from the config
    new_config = ""
    config.split("\n").each do |line|
      unless line.starts_with?('#')
        new_config+=line
      end
    end
    # if there are significant differences, return true
    if new_config != current_config.gsub("\n","")
      true
    else
      false
    end
  end
end