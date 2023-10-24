x = 0.1
y = 0.1
z = 0.1

z0 = z - 0.1392;
a1 = 0.135;
a2 = 0.147;


l = sqrt(x^2 + y^2);
D = sqrt(l^2 + z0^2);
% D must be < (a1+a2)

t1 = atan(z0/l)
t2 = acos(((a1^2)+(D^2)-(a2^2)) / (2*a1*D))
alpha = t1+t2
beta = acos(((a1^2)+(a2^2)-(D^2)) / (2*a1*a2))

q1 = (pi/2) - alpha;

q2_real = (pi) - beta - alpha;
q2_sim = (pi/2) - q1 + q2_real;

q3_real = 0;
q3_sim = (pi/2) - q2_sim - q1;

  if x==0
    q0 = (pi/2)*sign(y);
  else
    q0 = atan(y/x);
  end

q = [q0 q1 q2_sim q3_sim 0]

