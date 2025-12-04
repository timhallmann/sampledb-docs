import sys
import os

version_dir = os.path.abspath(os.environ.get('VERSION_DIR'))

# import variables from version-specific conf.py
sys.path.insert(0, version_dir)
from conf import *

# set required variables that are not set in older versions of the docs
language = 'en'

# override setup to ensure current version of loading CSS files
def setup(app):
    app.add_css_file('css/custom.css')

# fix relative paths
html_static_path = ['static', os.path.join(version_dir, 'static')]
templates_path = ['templates', os.path.join(version_dir, 'templates')]

# add version.html to html_sidebars
html_sidebars = {
    '**': [
        'about.html',
        'about_version.html',
        'searchfield.html',
        'navigation.html',
        'relations.html',
        'versions.html',
    ]
}
