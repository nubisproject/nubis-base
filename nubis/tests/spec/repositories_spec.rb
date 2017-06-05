require 'spec_helper'

osfamily = os[:family]

if osfamily == 'redhat'
  describe yumrepo('extras') do
    it { should be_exist   }
    it { should be_enabled }
  end
end

if osfamily == 'debian'
  describe file('/etc/apt/sources.list') do
    it { should exist }
    its(:size) { should eq 0 }
  end

  describe file('/etc/apt/sources.list.d') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

#puppetlabs.list
#treasure-data.list
end
