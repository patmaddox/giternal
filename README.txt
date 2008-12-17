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

Now in project root, run 'giternal update' to update all of your
git dependencies.

== FREEZING AND UNFREEZING:

Sometimes you want to freeze your dependencies, e.g. when deploying.
This lets you create a self-contained deploy tag with all externals at
a known, working version.  giternal will tar up the .git history dir
for each external, and then add the external to your git index.  You
can review all the changes before committing.

giternal freeze

Unfreezing, as you might guess, is the opposite of freezing.  It will
remove your external dir from the git index, and extract each
external's .git dir, restoring the history and allowing you to commit
or fetch changes.

giternal unfreeze

== NOTES:

* Deploying with vlad or capistrano simply requires you to run
  'giternal update' after the code has been checked out, if your
  externals are not frozen.  If deploying a codebase with frozen
  externals, there's nothing to do.

== INSTALL:

* sudo gem install giternal

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
