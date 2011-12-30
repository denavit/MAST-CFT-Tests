function base = baseForces(pos,tip)
% pos is the position of the tip w.r.t. the base
% tip is the tip forces
% base is the base forces


numSteps = size(pos,1);
base = zeros(numSteps,6);

for i = 1:numSteps
    r = pos(i,:); 
    f_tip = tip(i,1:3);
    m_tip = tip(i,4:6);
    
    f_base = -f_tip;
    m_base = -m_tip - cross(r,f_tip);
    
    base(i,:) = [ f_base m_base ];
end

return




