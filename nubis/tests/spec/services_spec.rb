require 'spec_helper'

# These shouldn't be enabled, our own startup logic starts it up
describe service('consul') do
  it { should_not be_enabled }
end

# These should be enabled
describe service('confd') do
  it { should be_enabled }
end

describe service('td-agent') do
  it { should be_enabled }
end

describe service('ntpd') do
  it { should be_enabled }
end
