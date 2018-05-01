function plot_settings = default_plot_settings();
% plot_settings = default_plot_settings();
%
% Default settings for plot's fontsize, boldface, linker control display, etc.
%
% (C) R. Das, Stanford University

plot_settings.fontsize    = 10;
plot_settings.spacing     =  3;
plot_settings.bp_spacing  =  6;
plot_settings.boldface    =  1;
plot_settings.show_stem_pairs = 1;
plot_settings.show_noncanonical_pairs = 1;
plot_settings.show_tertiary_noncanonical_pairs = 1;
plot_settings.show_extra_arrows    = 1;
plot_settings.show_stacks          = 0;
plot_settings.show_other_contacts  = 0;
plot_settings.show_domains         = 1;
plot_settings.show_helix_controls  = 1;
plot_settings.show_coax_controls   = 0;
plot_settings.show_domain_controls = 1;
plot_settings.show_linker_controls = 0;
