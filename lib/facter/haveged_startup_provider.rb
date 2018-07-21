# Return the provider of the init system by looking at PID 1
Facter.add(:haveged_startup_provider) do
  confine kernel: 'Linux'
  setcode do
    begin
      # Read command running as PID 1
      File.open('/proc/1/comm', &:readline).chomp
    rescue
      # Use init as default
      'init'
    end
  end
end
