require 'spec_helper'

describe package('dnsmasq') do
  it { should     be_installed }
end

describe package('sendmail') do
  it { should_not be_installed }
end

