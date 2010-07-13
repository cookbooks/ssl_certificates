define :ssl_certificate do
  
  name = params[:name] =~ /\*\.(.+)/ ? "#{$1}_wildcard" : params[:name]
  # gsub is required since databags can't contain dashes
  cert = search(:certificates, "name:#{name}").first
  
  template "#{node[:ssl_certificates][:path]}/#{name}.crt" do
    source "cert.erb"
    mode "0640"
    cookbook "ssl_certificates"
    owner "root"
    group "www-data"
    variables :cert => cert["cert"]
  end

  template "#{node[:ssl_certificates][:path]}/#{name}.key" do
    source "cert.erb"
    mode "0640"
    cookbook "ssl_certificates"
    owner "root"
    group "www-data"
    variables :cert => cert[:key]
  end

  template "#{node[:ssl_certificates][:path]}/#{name}_combined.crt" do
    source "cert.erb"
    mode "0640"
    cookbook "ssl_certificates"
    owner "root"
    group "www-data"
    variables :cert => cert[:intermediate] ? cert[:cert] + cert[:intermediate] : cert[:cert]
  end

end
