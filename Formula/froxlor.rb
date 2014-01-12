require "formula"

class Froxlor < Formula
  homepage "http://www.froxlor.org/"
  url "http://files.froxlor.org/releases/froxlor-0.9.31.2.tar.gz"
  sha1 "7ef60b51da9075448efa7af55857b4692645168d"
  version "0.9.31.2"

  # Webservers we will support
  if (build.include?('with-apache') && build.include?('with-nginx'))
    || (build.include?('with-nginx') && build.include?('with-lighttpd'))
    || (build.include?('with-apache') && build.include?('with-lighttpd'))

    raise "You cannot use more than one webserver with froxlor."
    super
  elsif build.include?('with-apache')
    depends_on 'apache2'
  elsif build.include?('with-lighttpd')
    depends_on 'lighttpd'
  else
    depends_on 'nginx'
  end

  # Install PHP
  if build.include?('with-apache')
    depends_on 'php55'
  else
    depends_on 'php55' => ['with-mysql', 'with-fpm', 'with-apache']
  end

  def install
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
