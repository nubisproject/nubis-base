describe user('centos') , :if => os[:family] == 'redhat' do
  it { should exist }
  it { should belong_to_group 'wheel' }
end

describe user('ec2-user') , :if => os[:family] == 'amazon' do
  it { should exist }
  it { should belong_to_group 'wheel' }
end

describe user('ubuntu') , :if => os[:family] == 'ubuntu' do
  it { should exist }
  it { should belong_to_group 'sudo' }
end
