
if os[:name] == 'amazon'
  describe package('docker') do
    it { should be_installed }
  end
else
  describe package('docker-ce') do
    it { should be_installed }
  end
end

describe file('/etc/docker/daemon.json') do
  it { should be_file }
  it { should be_owned_by 'root' }
end

describe json('/etc/docker/daemon.json') do
  its(['dns', 0]) { should eq '8.8.8.8' }
end

describe systemd_service('docker') do
  it { should be_installed }
  it { should be_enabled }
  it { should_not be_running }
end
