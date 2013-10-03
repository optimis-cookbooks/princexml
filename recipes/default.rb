package = 'prince-7.1-ubuntu904-amd64-dynamic'
file = "#{package}.tar.gz"

remote_file "/tmp/#{file}" do
  source "http://www.princexml.com/download/#{file}"
  mode 0644
  action :create_if_missing
  notifies :run, 'bash[install_princexml]', :immediately
end

bash 'install_princexml' do
  not_if '/usr/local/bin/prince --version | grep 7.1'
  user 'root'
  cwd '/tmp'
  code "tar -xvf #{file} && cd #{package} && ./install.sh"
  action :nothing
end

if node[:prince] && node[:prince][:license_cookbook]
  cookbook_file '/usr/local/lib/prince/license/license.dat' do
    backup 100
    mode 0444
    cookbook node[:prince][:license_cookbook]
  end
end