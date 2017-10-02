
describe package('docker-ce') do
  it { should be_installed }
  its('version') { should match(/^17\.06\.2/) }
end

describe file('/etc/docker/daemon.json') do
  it { should be_file }
  it { should be_owned_by 'root' }
  its('content') { should match(/"dns":\s*\[\s*"8.8.8.8",\s*"8.8.4.4"\s*\]/) }
end

if os[:release].to_i >= 16
  describe systemd_service('docker') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
else
  describe service('docker') do
    it { should be_installed }
    it { should be_running }
    it { should be_enabled }
  end
end

describe command('pip list') do
  its('exit_status') { should eql 0 }
  its('stdout') { should match(/^docker-py/) }
end
