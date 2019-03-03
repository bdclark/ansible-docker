
describe package('docker-ce') do
  it { should be_installed }
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
end

describe command('pip list') do
  its('exit_status') { should eql 0 }
  its('stdout') { should match(/^docker-py/) }
end
