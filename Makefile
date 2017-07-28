NAGIOS_PLUGINDIR := /usr/lib/nagios/plugins
NAGIOS_PLUGIN_ETC_DIR := /etc/nagios/
all:

install:
	[ -d $(DESTDIR)$(NAGIOS_PLUGIN_ETC_DIR) ] || mkdir -p $(DESTDIR)$(NAGIOS_PLUGIN_ETC_DIR)
	[ -d $(DESTDIR)$(NAGIOS_PLUGINDIR) ] || mkdir -p $(DESTDIR)$(NAGIOS_PLUGINDIR)
	[ -f $(DESTDIR)$(NAGIOS_PLUGIN_ETC_DIR)/check_obs_events.yml ] || \
	 install -m 644 etc/check_obs_events.yml $(DESTDIR)$(NAGIOS_PLUGIN_ETC_DIR)/check_obs_events.yml
	install -m 755 check_obs_events $(DESTDIR)$(NAGIOS_PLUGINDIR)/check_obs_events

test:
	@perl -It -c ./check_obs_events
	@prove -It t/*.t
