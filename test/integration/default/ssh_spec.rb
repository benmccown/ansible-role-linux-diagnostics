control 'ssh-on' do
title 'Port 22 is listening'
desc 'SSH should be enabled and listening'
impact 1.0 # This is critical
  describe port(22) do
    it { should be_listening }
  end
  describe service('sshd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
