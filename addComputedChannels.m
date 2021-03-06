function data = addComputedChannels(specimen,data)

% Base Forces
tipPosition = [data.X_Displ data.Y_Displ specimen.L+data.Z_Displ];
tipForces   = [data.X_Force data.Y_Force data.Z_Force data.RX_Force data.RY_Force data.RZ_Force];
iBaseForces  = baseForces(tipPosition,tipForces);
data.X_Force_Base  = iBaseForces(:,1);
data.Y_Force_Base  = iBaseForces(:,2);
data.Z_Force_Base  = iBaseForces(:,3);
data.RX_Force_Base = iBaseForces(:,4);
data.RY_Force_Base = iBaseForces(:,5);
data.RZ_Force_Base = iBaseForces(:,6);

data.Mx1_Base = -specimen.L*data.Y_Force;
data.My1_Base =  specimen.L*data.X_Force;


end