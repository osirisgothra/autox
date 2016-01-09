shopt-bash-README.txt

quick note about the shopt-bash files in /etc/static

these are so far know states for bash (usually 4.3)
and their initial and recommended states.

The initial is the shopts just after a 'bash --norc' run
which starts with NO configuration at all.

The vendor state is the shopts that are set after a run
on a newly installed bash, bash_completion, and surrounding
toolset that usually comes with most free linux installs.

(free as in price, not the GNU free that means freedom).

These are important files because:

1) autox uses these to keep settings clean during runs that
   drastically set the settings to something else, or after
   running some third party tool that may do the same. Also
   since we can't predict what the user may break, we must
   have some sort of starting point.
   
2) when we run tests on shell script 'fragments' such as an
   alias or a func, even a dynamic variable, we use a new
   instance of bash to lint the file (-n) as most usually do,
   so we use this file to init that shell, so we dont need
   to load all of autox just to lint the thing, that would be
   way to slow -- not to mention would probably cause a cycle
   infinite!!

3) the comparison to your own settings can give you an idea of
   what you should use in your own scripts or addons and a file
   you can source out to get the initial state when you start,
   or cleanup the shopts after your done.
   
But I hate these settings!

Well, thats why they are in files here, we say static but you can
set them if you know what you are doing, by modifying them yourself
as long as you know what changes they will impose. One wrong setting
can (extglob and errexit, for example) cause bash to become unresponsive
or even crash instantly whenever you log in, without fail!

Is there a settings editor of some sort?

Not yet, but it is planned. Once the autox cui is done, it will be a part of it.
The vast namespace that is being constructed is part of this. 

please see the website, autox.github.io, or email the author (README) for more
info. For installing, see INSTALLATION. For licensing please read the GNU GPL3
and the LICENSE file provided with the package.



