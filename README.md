# [PSRC.org Website](http://psrc.org)
## Big picture
- Currently running rails v2.0.2.
- CMS built on Radiant CMS.
- Deploys to BlueBox using capistrano.

## Notes
- In production the app runs with apache/passenger. Apache redirects can be defined in `/sites/psrc-production/shared/htaccess`. This file is symlinked to the public dir (which is the apache root) on cap deploy.