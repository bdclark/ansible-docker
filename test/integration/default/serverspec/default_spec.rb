require 'spec_helper'

describe service('docker') do
  it { should be_running }
  it { should be_enabled }
end

describe file('/etc/default/docker') do
  it { should be_file }
  its(:content) { should match(/^DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4"$/) }
end

if os[:release] == '16.04'
  describe service('docker') do
    it { should be_running.under('systemd') }
  end

  describe file('/etc/systemd/system/docker.service.d/environment.conf') do
    it { should be_file }
    its(:content) { should match(/^EnvironmentFile=-\/etc\/default\/docker$/) }
  end

  describe command('systemctl show docker | grep EnvironmentFile') do
    its(:stdout) { should contain 'EnvironmentFile=/etc/default/docker' }
  end
end

describe command('pip list') do
  its(:exit_status) { should eql 0 }
  its(:stdout) { should match(/^docker-py/) }
end
