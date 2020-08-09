function pcb_enclosure_bolt_base_size(bolt_size) =
    bolt_size * 2;
function pcb_enclosure_body_length_internal(pcb_length, pcb_clearance) =
    pcb_length + pcb_clearance;
function pcb_enclosure_body_length(pcb_length, pcb_clearance) =
    pcb_enclosure_body_length_internal(pcb_length, pcb_clearance);
function pcb_enclosure_body_width_internal(pcb_width, pcb_clearance) =
    pcb_width + pcb_clearance;
function pcb_enclosure_body_width(pcb_width, pcb_clearance, wall_thickness) =
    pcb_enclosure_body_width_internal(pcb_width, pcb_clearance) +
        (2 * wall_thickness);
function pcb_enclosure_body_height_internal(pcb_height, pcb_clearance,
                                            pcb_thickness, bolt_size,
                                            wall_thickness) =
    pcb_enclosure_bolt_base_size(bolt_size) - wall_thickness + pcb_height +
        pcb_clearance + pcb_thickness;
function pcb_enclosure_body_height(pcb_height, pcb_clearance, pcb_thickness,
                                   bolt_size, wall_thickness) =
    pcb_enclosure_body_height_internal(pcb_height, pcb_clearance,
                                       pcb_thickness, bolt_size,
                                       wall_thickness) + (2 * wall_thickness);

module _foot(x, y, h, foot_radius) {
    translate([x, y, 0])
        cylinder(h=h, r1=foot_radius/2, r2=foot_radius, $fn = 20);
}

module _bolt_base(y, z, bolt_size, length) {
    translate([0, y - bolt_size, z - bolt_size])
        cube([length,
              pcb_enclosure_bolt_base_size(bolt_size),
              pcb_enclosure_bolt_base_size(bolt_size)]);
}

module _bolt_hole(y, z, bolt_radius, length) {
    rotate([0, 90, 0])
        translate([-z, y, 0])
            cylinder(h=length, r1=bolt_radius, r2=bolt_radius, $fn = 20);
}

module _pcb_holder(y, z, pcb_holder_size, length) {
    translate([0, y - pcb_holder_size / 2, z - pcb_holder_size / 2])
        cube([length, pcb_holder_size, pcb_holder_size]);
}

module pcb_enclosure_body(pcb_length, pcb_width, pcb_height, pcb_thickness,
                          pcb_clearance, pcb_holder_size, wall_thickness,
                          foot_margin, foot_radius, bolt_size,
                          bolt_hole_ratio) {
    box_base_z = foot_radius / 2;
    bolt_radius = (bolt_size * bolt_hole_ratio) / 2;
    rotate([0, -90, -90]) {
        translate([0, 0, -box_base_z]) {
            to_center = foot_margin + foot_radius;
            _foot(to_center - wall_thickness,
                  to_center,
                  box_base_z,
                  foot_radius);
            _foot(to_center - wall_thickness,
                  pcb_enclosure_body_width_internal(pcb_width, pcb_clearance) +
                      wall_thickness - to_center,
                  box_base_z,
                  foot_radius);
            _foot(pcb_enclosure_body_length_internal(pcb_length, pcb_clearance) +
                      wall_thickness - to_center,
                  to_center,
                  box_base_z,
                  foot_radius);
            _foot(pcb_enclosure_body_length_internal(pcb_length, pcb_clearance) +
                      wall_thickness - to_center,
                  pcb_enclosure_body_width_internal(pcb_width, pcb_clearance) +
                      wall_thickness - to_center,
                  box_base_z,
                  foot_radius);
        }
        difference() {
            union() {
                difference() {
                    cube([pcb_enclosure_body_length(pcb_length, pcb_clearance),
                          pcb_enclosure_body_width(pcb_width, pcb_clearance,
                                                   wall_thickness),
                          pcb_enclosure_body_height(pcb_height, pcb_clearance,
                                                    pcb_thickness, bolt_size,
                                                    wall_thickness)]);
                    translate([0, wall_thickness, wall_thickness])
                        cube([pcb_enclosure_body_length_internal(pcb_length,
                                                                 pcb_clearance),
                              pcb_enclosure_body_width_internal(pcb_width,
                                                                pcb_clearance),
                              pcb_enclosure_body_height_internal(pcb_height,
                                                                 pcb_clearance,
                                                                 pcb_thickness,
                                                                 bolt_size,
                                                                 wall_thickness)]);
                }

                to_center = wall_thickness + (pcb_holder_size / 2);
                pcb_z = to_center + pcb_enclosure_bolt_base_size(bolt_size) -
                    wall_thickness + pcb_clearance + pcb_thickness;
                _pcb_holder(to_center,
                            pcb_z,
                            pcb_holder_size,
                            pcb_enclosure_body_length(pcb_length,
                                                      pcb_clearance));
                _pcb_holder(pcb_enclosure_body_width(pcb_width, pcb_clearance,
                                                     wall_thickness) - to_center,
                            pcb_z,
                            pcb_holder_size,
                            pcb_enclosure_body_length(pcb_length,
                                                      pcb_clearance));

                _bolt_base(bolt_size,
                           bolt_size,
                           bolt_size,
                           pcb_enclosure_body_length(pcb_length,
                                                     pcb_clearance));
                _bolt_base(pcb_enclosure_body_width(pcb_width, pcb_clearance,
                                                    wall_thickness) - bolt_size,
                           bolt_size,
                           bolt_size,
                           pcb_enclosure_body_length(pcb_length,
                                                     pcb_clearance));
                _bolt_base(bolt_size,
                           pcb_enclosure_body_height(pcb_height, pcb_clearance,
                                                     pcb_thickness, bolt_size,
                                                     wall_thickness) - bolt_size,
                           bolt_size,
                           pcb_enclosure_body_length(pcb_length,
                                                     pcb_clearance));
                _bolt_base(pcb_enclosure_body_width(pcb_width, pcb_clearance,
                                                    wall_thickness) - bolt_size,
                           pcb_enclosure_body_height(pcb_height, pcb_clearance,
                                                     pcb_thickness, bolt_size,
                                                     wall_thickness) - bolt_size,
                           bolt_size,
                           pcb_enclosure_body_length(pcb_length,
                                                     pcb_clearance));
            }

            _bolt_hole(bolt_size,
                       bolt_size,
                       bolt_radius,
                       pcb_enclosure_body_length(pcb_length, pcb_clearance));
            _bolt_hole(pcb_enclosure_body_width(pcb_width, pcb_clearance,
                                                wall_thickness) - bolt_size,
                       bolt_size,
                       bolt_radius,
                       pcb_enclosure_body_length(pcb_length, pcb_clearance));
            _bolt_hole(bolt_size,
                       pcb_enclosure_body_height(pcb_height, pcb_clearance,
                                                 pcb_thickness, bolt_size,
                                                 wall_thickness) - bolt_size,
                       bolt_radius,
                       pcb_enclosure_body_length(pcb_length, pcb_clearance));
            _bolt_hole(pcb_enclosure_body_width(pcb_width, pcb_clearance,
                                                wall_thickness) - bolt_size,
                       pcb_enclosure_body_height(pcb_height, pcb_clearance,
                                                 pcb_thickness, bolt_size,
                                                 wall_thickness) - bolt_size,
                       bolt_radius,
                       pcb_enclosure_body_length(pcb_length, pcb_clearance));
        }
    }
}

module _end_pcap_hole(x, y, h, bolt_radius) {
    translate([x, y, 0])
        cylinder(h=h, r1=bolt_radius, r2=bolt_radius, $fn = 20);
}

module pcb_enclosure_end_cap(pcb_width, pcb_height, pcb_thickness,
                             pcb_clearance, wall_thickness, bolt_size,
                             bolt_hole_ratio) {
    bolt_radius = (bolt_size * bolt_hole_ratio) / 2;
    difference() {
        cube([pcb_enclosure_body_width(pcb_width, pcb_clearance,
                                       wall_thickness),
              pcb_enclosure_body_height(pcb_height, pcb_clearance,
                                        pcb_thickness, bolt_size,
                                        wall_thickness),
              wall_thickness]);
        _end_pcap_hole(bolt_size,
                       bolt_size,
                       wall_thickness,
                       bolt_radius);
        _end_pcap_hole(bolt_size,
                       pcb_enclosure_body_height(pcb_height, pcb_clearance,
                                                 pcb_thickness, bolt_size,
                                                 wall_thickness) - bolt_size,
                       wall_thickness,
                       bolt_radius);
        _end_pcap_hole(pcb_enclosure_body_width(pcb_width, pcb_clearance,
                                                wall_thickness) - bolt_size,
                       bolt_size,
                       wall_thickness,
                       bolt_radius);
        _end_pcap_hole(pcb_enclosure_body_width(pcb_width, pcb_clearance,
                                                wall_thickness) - bolt_size,
                       pcb_enclosure_body_height(pcb_height, pcb_clearance,
                                                 pcb_thickness, bolt_size,
                                                 wall_thickness) - bolt_size,
                       wall_thickness,
                       bolt_radius);
    }
}
