require 'spec_helper'

describe 'ssh_hardening::server' do

  let(:facts) {{
    :osfamily => 'redhat'
  }}

  it do
    should contain_file('/etc/ssh').with({
      'ensure' => 'directory',
      'owner' => 'root',
      'group' => 'root',
      'mode' => '0755'
    })
  end

end