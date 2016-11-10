#Audiokinetic Jukebox (AkJ)#
The Audiokinetic Jukebox (AkJ) is a collection of software which manages the 
playback of multisensory compositions for various hardware platforms in use 
at the Audiokinetic Experiments (AkE) labs (RMIT Melbourne).

Future releases will focus on: 
* Dropping dependencies on desktop applications
* moving towards a server-client model with a REST-API 
* web, mobile and desktop clients.

##Dependencies##
* Any XDG-compliant desktop environment (only GNOME has been tested)
* systemd
* jackd
* Pure Data
* a2jmidid
* py-liblo
* python3
* Ardour 5.x (only tested with Ardour 5.4)

##Installation##
	cd akj
	./install.sh

##Launch##
	akj start

##Stop##
	akj stop

##Restart##
	akj restart

##Reload##
	akj reload

##Gotchas##
At the moment the software suite is designed to be launched upon login to a
XDG compliant desktop. I'd recommend adding a specific user for this role.

The AkJ is being developed on Debian 9 "Stretch", which currently ships Ardour
version 5.4.0. The OSC features currently being deployed are probably specific 
to the 5.x series, though we've only tested under 5.4.0. 

By default the unit files look for a Pd patch under `~/pd/akj.pd` which 
receives MIDI data from Ardour. Ardour is launched with a project called 
`~/Ardour/akj/akj.ardour`. Expect more flexibility in future relases.

By default `jackd` is launched in stereo on the first available soundcard, with 
no input channels enabled. Update `.config/systemd/user/jackd.service` to suit
your requirements. For more see `jackd --help`.

##Troubleshooting##
###Ardour MIDI###
In case Pd fails to receive MIDI data make sure Ardour uses the `a2jmidid` port
in the routing grid. Save your changes, restart all services (`akj restart`) to 
ensure the MIDI is making it through.

###Ardour Looping###
When setting up your Ardour project you will need to manually set your loop 
range. Save and quit normally to make sure your changes stick. Then restart all
services.

###Timing###
The order of dependencies is crucial in this application and some, most notably
JACK and Ardour, take several seconds to launch. To handle this the `ExecPre`
sections of several of the services have some (crude) calls to `/bin/sleep`. The
order of execution is as follows (in seconds):

* 0  - JACK
* 3  - Pd
* 4  - a2jmidid
* 5  - Ardour
* 10 - OSC loop script

Feel free to edit the `.service` files to suit your needs, and remember to 
`akj reload` your changes.

##Roadmap##
###0.2###
* REST API
* Web client
* Transport controls
* Auto-calculate loop parameters
* Support for multiple tracks
	* sqlite backend/file format

###0.3###
* Custom `sndio` daemon
* Drop depencies on Ardour, Pd, a2jmidid, jackd and Xorg
* BSD support

###0.4###
* mobile clients
* GTK+ client
* macOS client
