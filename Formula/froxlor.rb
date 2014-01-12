require "formula"

class Froxlor < Formula
  homepage "http://www.froxlor.org/"
  url "http://files.froxlor.org/releases/froxlor-0.9.31.2.tar.gz"
  sha1 "7ef60b51da9075448efa7af55857b4692645168d"
  version "0.9.31.2"

  # Webservers we will support
  if (build.include?('with-apache') && build.include?('with-nginx')) || (build.include?('with-nginx') && build.include?('with-lighttpd')) || (build.include?('with-apache') && build.include?('with-lighttpd'))

    raise "You cannot use more than one webserver with froxlor."
    super
  elsif build.include?('with-apache')
    # No dependecies as apache2 comes with OS X
  elsif build.include?('with-lighttpd')
    depends_on 'lighttpd'
  else
    depends_on 'nginx'
  end

  # Check PHP
  if build.include?('with-apache')
    depends_on 'php55' => ['with-mysql']
  else
    depends_on 'php55' => ['with-mysql', 'with-fpm', 'without-apache']
  end
  
  # Check MySQL
  depends_on "mysql"

  def install
    puts "Please enter your password so we can move the launchctl files into place."
    # Start PHP-FPM if needed
    if !build.include?('with-apache')
      system "sudo ln -sfv /usr/local/opt/php55/*.plist ~/Library/LaunchAgents/homebrew.mxcl.php55-fpm.plist"
      system "launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.php55-fpm.plist"
    end
    
    # Start MySQL
    system "sudo ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
    system "launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
    
    # Move froxlor into place and start webserver
    if build.include?('with-apache')
      system "mv", buildpath, "/usr/local/opt/apache/"
      system "sudo apachectl start"
    elsif build.include?('with-lighttpd')
      system "mv", buildpath, "/usr/local/opt/lighttpd/"
      system "sudo ln -sfv /usr/local/opt/lighttpd/*.plist ~/Library/LaunchAgents/homebrew.mxcl.lighttpd.plist"
      system "sudo launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.lighttpd.plist"
    else
      system "mv", buildpath, "/usr/local/opt/nginx/html/"
      system "sudo ln -sfv /usr/local/opt/nginx/*.plist ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist"
      system "sudo launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist"
    end

    system "mv", buildpath, @wwwroot
    
    # ENV.deparallelize  # if your formula fails when building in parallel

    # Remove unrecognized options if warned by configure
    #system "./configure", "--disable-debug",
    #                      "--disable-dependency-tracking",
    #                      "--disable-silent-rules",
    #                      "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    #system "make", "install" # if this fails, try separate make/make install steps
  end
end
