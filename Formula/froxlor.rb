require 'formula'

class Froxlor < Formula
  init
  homepage  'http://www.froxlor.org/'
  url       'http://files.froxlor.org/releases/froxlor-0.9.31.2.tar.gz'
  sha1      '7ef60b51da9075448efa7af55857b4692645168d'
  head      'https://github.com/Froxlor/Froxlor.git'
  version   '0.9.31.2'
  
  depends_on 'php55'
  depends_on 'mysql'
  
  # Webservers we will support
  if build.include?('with-apache2') ^ build.include?('with-nginx') ^ build.include?('with-lighttpd')
    raise "Cannot specify more than one webserver to depend on."
  end
  
  depends_on 'apache2' if build.include?('with-apache2')
  depends_on 'nginx' if build.include?('with-nginx')
  depends_on 'lighttpd' if build.include?('with-lighttpd')
end