require 'spec_helper'

# These shouldn't be enabled, our own startup logic starts it up
describe service('consul') do
  it { should_not be_enabled }
end

describe service('node_exporter') do
  it { should_not be_enabled }
end

# These should be enabled
describe service('sshd') do
  it { should be_enabled }
end

describe service('td-agent') do
  it { should be_enabled }
end

describe service('ntpd'),  :if => os[:family] == 'redhat' do
  it { should be_enabled }
end

describe service('ntp'),  :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
end
