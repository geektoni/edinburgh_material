%%%%%%IAF simulation (this is the only file the students will get).
% it is not necessary to edit this file.

dt		= 1;	% timestep in ms
endtime = 20*1e3; % in ms
ndt   	= endtime/dt;
stim  	= zeros(1,ndt);
spikes  = zeros(1,ndt); % 1 for spike,0 otherwise

timesincelastspike= zeros(1,ndt); % time elapsed since last spike.
% Note: at the time of a spike, it is not yet set to zero, 
% but it equals the time since previous spike

timesincelastspike(1)	= 1; % assume we just had a spike
timesincelastspike(2)	= 2;

% stimulus parameters, do not edit
stim_sd	= 40;
stim_tau= 0.1; 

noise_decay = exp(-dt/stim_tau);
stim_sdb = stim_sd*sqrt(2.0*dt/stim_tau);

% neuron parameters, do not edit
vrest   = -70;
vreset  = -70;
vthr   	= -50;
tau_mem = 10;
spikes  = zeros(1,ndt);
vmem    = vrest*ones(1,ndt);
imean   = 20;
rand ('state', 1); % repeat same noise each time
for itime= 2:ndt
    stim(itime)= stim(itime-1)*noise_decay+ stim_sd*randn;
    i = imean + stim(itime);
    vmem(itime) = vmem(itime-1)+ dt/tau_mem*(-(vmem(itime-1)-vrest') +i);

	timesincelastspike(itime+1)= timesincelastspike(itime)+1;
    if (vmem(itime)> vthr)
        spikes(itime)=1;
		timesincelastspike(itime+1) = 1;
        vmem(itime) = vreset;
    end
end
timesincelastspike = timesincelastspike(1:ndt); 
nspikes = sum(spikes);
av_rate = nspikes /endtime*1e3	% in Hz

% calculate intervals
ti	= find(spikes);
ti2 = ti(2:length(ti));
isi	= ti2-ti(1:length(ti)-1);

