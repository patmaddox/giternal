= giternal

== DESCRIPTION:

Giternal provides dead-simple management of external git
dependencies. It only stores a small bit of metadata, letting you
actively develop in any of the repos. Come deploy time, you can easily
freeze freeze all the dependencies to particular versions

== SYNOPSIS:

In your project root, create a file called config/giternal.yml.  This
file should contain a list of externals in the following format:

name:
  repo: git://url/to/repo.git
  path: local/path/dir

For example, to add the rspec and rspec-rails plugins to your project,
add the following to config/giternal.yml

rspec:
  repo: git://github.com/dchelimsky/rspec.git
  path: vendor/plugins
rspec-rails:
  repo: git://github.com/dchelimsky/rspec-rails.git
  path: vendor/plugins

Now in project root, run 'sake giternal:update' to update all of your
git dependencies.

== NOTES:

* You're probably using git for your own version control...and if so, you need to add the giternal'd paths to .gitignore.  You don't want to check them into version control!!

* Deploying with vlad or capistrano simply requires you to run 'sake giternal:update' after the code has been checked out

== REQUIREMENTS:

* sake

== INSTALL:

* sudo gem install giternal
* sudo sake -i 'http://giternal.rubyforge.org/git?p=giternal.git;a=blob_plain;f=lib/tasks/giternal.rake;hb=HEAD'

== LICENSE:

(The MIT License)

Copyright (c) 2008 Pat Maddox

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
