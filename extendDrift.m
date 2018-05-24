function sol = extendDrift( sol, p )
%% EXTENDDRIFT
%   Our nonLinear solver stops just after starting to drift
%   Take those final inputs and velocity states, and extend the drift

% Variables to extend:
%   iterations: [ t, dt ]
%   all inputs: [ Tr, delta ]
%   all states: [ xE, yN, Psi, Ux, Uy, r ]


%% Parse data
t     = sol.t;
dt    = sol.variable.dt;
Tr    = sol.input.Tr;
delta = sol.input.delta;
xE    = sol.state.xE;
yN    = sol.state.yN;
Psi   = sol.state.Psi;
Ux    = sol.state.Ux;
Uy    = sol.state.Uy;
r     = sol.state.r;


%% Do the thing
% stop extend conditions? 3/4, when yN_extend < yN(end) - R
stopY = yN(end) - p.R;
while yN(end) > stopY
    
    % iteration info
    dt    = [dt,    dt(end)];
    t     = [t,     dt(end)  + t(end)];
    
    % inputs
    Tr    = [Tr,    Tr(end)];
    delta = [delta, delta(end)];
    
    % states
    Ux    = [Ux,    Ux(end)];
    Uy    = [Uy,    Uy(end)];
    r     = [r,     r(end)];
        % Euler integration
    xE    = [xE,    xE(end)  - (Ux(end)*sin(Psi(end)) + Uy(end)*cos(Psi(end)))*dt(end)];
    yN    = [yN,    yN(end)  + (Ux(end)*cos(Psi(end)) - Uy(end)*sin(Psi(end)))*dt(end)];
    Psi   = [Psi,   Psi(end) + r(end)*dt(end)];
end

%% Pack data
sol.t           = t;
sol.variable.dt = dt;
sol.input.Tr    = Tr;
sol.input.delta = delta;
sol.state.xE    = xE;
sol.state.yN    = yN;
sol.state.Psi   = Psi;
sol.state.Ux    = Ux;
sol.state.Uy    = Uy;
sol.state.r     = r;

end
