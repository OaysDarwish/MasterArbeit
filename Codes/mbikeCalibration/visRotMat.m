function [Phi, Theta, Psi] = visRotMat(r)
%VISROTMAT visualizes a rotation matrix
%   Input: r is a 3-by-3 orthogonal rotation matrix

    figure
    for i=1:3
        plot3([0 r(1+3*(i-1))], [0 r(2+3*(i-1))], [0 r(3+3*(i-1))])
        hold on
    end
    
    grid on
    axis equal
%     axis vis3d
    rotate3d on
    legend({'x''','y''','z'''})
    xlabel('x_b'),ylabel('y_b'),zlabel('z_b')
    
    eulAng = rad2deg(rotm2eul(r));
    Phi = eulAng(3);
    Theta = eulAng(2);
    Psi = eulAng(1);
    
    title(sprintf('\\Phi: %.0f\\circ, \\Theta: %.0f\\circ, \\Psi: %.0f\\circ', ...
        Phi, Theta, Psi))
end

