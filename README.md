# ourfeed.public

To use this, add the following to your feeds.conf or feeds.conf.default:

src-git ourfeed.public https://github.com/augustgermar/ourfeed.public/

Then run ./scripts/feeds update -a && ./scripts/feeds install -a in your buildroot. After that run make menuconfig and you should see the apps selectable under luci --> applications

Good luck!
