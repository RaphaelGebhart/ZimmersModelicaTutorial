within Tutorial2024.StepByStep;
model Step10_PositionControl
  "Electrically Actuated Crane Crab with Position Control"
    extends Modelica.Icons.Example;

  inner PlanarMechanics.PlanarWorld planarWorld
    annotation (Placement(transformation(extent={{-122,-80},{-102,-60}})));
  PlanarMechanics.Parts.Body carriage(m=1, I=0.001)
    annotation (Placement(transformation(extent={{-22,-30},{-2,-10}})));
  PlanarMechanics.Parts.Fixed fixed annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-102,-20})));
  PlanarMechanics.Parts.Body pendulum(m=0.5, I=0.001)
    annotation (Placement(transformation(extent={{12,-80},{32,-60}})));
  PlanarMechanics.Parts.FixedTranslation rod(r={0,0.5})
    annotation (Placement(transformation(extent={{-32,-80},{-12,-60}})));
  PlanarMechanics.Joints.Revolute revolute1(useFlange=true, phi(start=
          0.26179938779915, fixed=true))
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-42,-50})));
  PlanarMechanics.Joints.Prismatic prismatic(useFlange=true, r={1,0})
    annotation (Placement(transformation(extent={{-62,-10},{-42,-30}})));
  Modelica.Electrical.Machines.BasicMachines.DCMachines.DC_PermanentMagnet dcpm(
    Jr=0,
    VaNominal=12,
    useThermalPort=false,
    Ra=0.05,
    alpha20a(displayUnit="1/K") = 0,
    La=0.0015,
    useSupport=false,
    Js=0,
    TaOperational=293.15,
    IaNominal=1,
    wNominal(displayUnit="rad/s") = 100,
    TaNominal=293.15,
    TaRef=293.15)
    annotation (Placement(transformation(extent={{-102,10},{-82,30}})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-130,10},{-110,30}})));
  Modelica.Mechanics.Translational.Components.IdealGearR2T idealGearR2T(ratio=100)
    annotation (Placement(transformation(extent={{-82,10},{-62,30}})));
  Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor
    annotation (Placement(transformation(extent={{-22,-60},{-2,-40}})));
  Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent
    annotation (Placement(transformation(extent={{-112,40},{-92,60}})));
  Modelica.Blocks.Continuous.PID PID_phi(
    k=-5,
    Ti=1e10,
    Td=0.2) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={106,84})));
  Modelica.Blocks.Continuous.PID PID_s(
    k=1,
    Ti=1e10,
    Td=0.8) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={70,20})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{18,30},{38,10}})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-40,78})));
  Modelica.Mechanics.Translational.Sensors.PositionSensor positionSensor
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=1,
    duration=1,
    offset=0,
    startTime=7)
    annotation (Placement(transformation(extent={{-26,40},{-6,60}})));
equation
  connect(rod.frame_b, pendulum.frame_a) annotation (Line(
      points={{-12,-70},{12,-70}},
      color={95,95,95},
      thickness=0.5));
  connect(revolute1.frame_b, rod.frame_a) annotation (Line(
      points={{-42,-60},{-42,-70},{-32,-70}},
      color={95,95,95},
      thickness=0.5));
  connect(revolute1.frame_a, carriage.frame_a) annotation (Line(
      points={{-42,-40},{-42,-20},{-22,-20}},
      color={95,95,95},
      thickness=0.5));
  connect(fixed.frame, prismatic.frame_a) annotation (Line(
      points={{-92,-20},{-62,-20}},
      color={95,95,95},
      thickness=0.5));
  connect(prismatic.frame_b, carriage.frame_a) annotation (Line(
      points={{-42,-20},{-22,-20}},
      color={95,95,95},
      thickness=0.5));
  connect(ground.p, dcpm.pin_an)
    annotation (Line(points={{-120,30},{-98,30}},color={0,0,255}));
  connect(revolute1.frame_a, prismatic.frame_b) annotation (Line(
      points={{-42,-40},{-42,-20}},
      color={95,95,95},
      thickness=0.5));
  connect(dcpm.flange, idealGearR2T.flangeR)
    annotation (Line(points={{-82,20},{-82,20}}, color={0,0,0}));
  connect(idealGearR2T.flangeT, prismatic.flange_a) annotation (Line(points={{-62,20},
          {-52,20},{-52,-10}},         color={0,127,0}));
  connect(ground.p, signalCurrent.p)
    annotation (Line(points={{-120,30},{-120,50},{-112,50}}, color={0,0,255}));
  connect(signalCurrent.n, dcpm.pin_ap)
    annotation (Line(points={{-92,50},{-86,50},{-86,30}}, color={0,0,255}));
  connect(angleSensor.flange, revolute1.flange_a)
    annotation (Line(points={{-22,-50},{-32,-50}}, color={0,0,0}));
  connect(angleSensor.phi, PID_phi.u) annotation (Line(points={{-1,-50},{128,
          -50},{128,84},{118,84}}, color={0,0,127}));
  connect(add.u2, PID_phi.y)
    annotation (Line(points={{-28,84},{95,84}}, color={0,0,127}));
  connect(add.u1, PID_s.y) annotation (Line(points={{-28,72},{90,72},{90,20},{
          81,20}}, color={0,0,127}));
  connect(add.y, signalCurrent.i)
    annotation (Line(points={{-51,78},{-102,78},{-102,62}}, color={0,0,127}));
  connect(idealGearR2T.flangeT, positionSensor.flange)
    annotation (Line(points={{-62,20},{-40,20}}, color={0,127,0}));
  connect(PID_s.u, feedback.y)
    annotation (Line(points={{58,20},{37,20}}, color={0,0,127}));
  connect(positionSensor.s, feedback.u1)
    annotation (Line(points={{-19,20},{20,20}}, color={0,0,127}));
  connect(ramp.y, feedback.u2)
    annotation (Line(points={{-5,50},{28,50},{28,28}}, color={0,0,127}));
  annotation (experiment(
      StopTime=15,
      __Dymola_NumberOfIntervals=1500,
      __Dymola_Algorithm="Dassl"),
    Diagram(coordinateSystem(extent={{-140,-100},{140,100}})),
    Icon(coordinateSystem(extent={{-140,-100},{140,100}})));
end Step10_PositionControl;
