# shutter-chevereto-uploader
[Shutter](https://shutter-project.org/) plugin for uploading to [Chevereto](https://chevereto.com/).

Chevereto.pm fully vibe coded by GPT-6 Luna  
README.md fully brain written by human

Tested with Shutter v0.99.2 r1593 and Chevereto v4.5.9

## Installation
1. Copy ``Chevereto.pm`` to ``/usr/share/shutter/resources/system/upload_plugins/upload/``
2. Restart Shutter
## Configuration
1. In Shutter navigate to: **Edit** › **Preferences** › **Upload**
2. Under the **Host** column locate **Chevereto** and click on the **Username** field next to it
3. Enter the base URL of the Chevereto server here. Include the protocol, but *do not* include a trailing slash:  
``https://images.example.com``
4. In a browser log into the Chevereto server, click on your username in the upper-right corner, then navigate to: **Settings** › **API**
5. Locate your Chevereto **API key** on this page and copy it. Note the warning: "Store the API key in a secure location as it will be shown just once."
6. Return to the Shutter **Preferences** dialog box and click on the **Password** field in the **Chevereto** row
7. Enter your Chevereto API key here and close the **Preferences** dialog box
## Usage
1. In Shutter click on an image then click on the **Export** toolbar button to open the **Import/Export** dialog box with the **Public hosting** tab displayed
2. Open the **Choose account:** drop-down menu, click on **Chevereto https://...** then click the **Upload** button
3. After a few seconds Shutter will display a pop-up with various Chevereto links to your image
