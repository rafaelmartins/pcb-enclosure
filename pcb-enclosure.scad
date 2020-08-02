module _feet(x, y, h, feet_radius) {
    translate([x, y, 0])
        cylinder(h=h, r1=feet_radius/2, r2=feet_radius, $fn = 20);
}

module _bolt_base(y, z, bolt_size, length) {
    translate([0, y - bolt_size, z - bolt_size])
        cube([length, bolt_size * 2, bolt_size * 2]);
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

module pcb_enclosure_body(pcb_length, pcb_width, pcb_height, pcb_thickness=1.6,
                          pcb_clearance=0.2, pcb_holder_size=1, wall_thickness=2,
                          feet_margin=5, feet_radius=3, bolt_size=2,
                          bolt_hole_ratio=0.95) {

    // FIXME: convert these into functions
    pcb_height_bottom = (bolt_size * 2) - wall_thickness;
    length_int = pcb_length + pcb_clearance;
    length = length_int;
    width_int = pcb_width + pcb_clearance;
    width = width_int + (2 * wall_thickness);
    height_int = pcb_height + pcb_height_bottom + pcb_clearance + pcb_thickness;
    height = height_int + (2 * wall_thickness);    
    box_base_z = feet_radius / 2;
    bolt_radius = (bolt_size * bolt_hole_ratio) / 2;

    to_center = feet_margin + feet_radius;
    _feet(to_center, to_center, box_base_z, feet_radius);
    _feet(to_center, width - to_center, box_base_z, feet_radius);
    _feet(length - to_center, to_center, box_base_z, feet_radius);
    _feet(length - to_center, width - to_center, box_base_z, feet_radius);

    translate([0, 0, box_base_z]) {
        difference() {
            union() {
                difference() {
                    cube([length, width, height]);
                    translate([0, wall_thickness, wall_thickness])
                        cube([length_int, width_int, height_int]);
                }

                to_center = wall_thickness + (pcb_holder_size / 2);
                pcb_z = to_center + pcb_height_bottom + pcb_clearance + pcb_thickness;
                _pcb_holder(to_center, pcb_z, pcb_holder_size, length);
                _pcb_holder(width - to_center, pcb_z, pcb_holder_size, length);

                _bolt_base(bolt_size, bolt_size, bolt_size, length);
                _bolt_base(width - bolt_size, bolt_size, bolt_size, length);
                _bolt_base(bolt_size, height - bolt_size, bolt_size, length);
                _bolt_base(width - bolt_size, height - bolt_size, bolt_size, length);
            }

            _bolt_hole(bolt_size, bolt_size, bolt_radius, length);
            _bolt_hole(width - bolt_size, bolt_size, bolt_radius, length);
            _bolt_hole(bolt_size, height - bolt_size, bolt_radius, length);
            _bolt_hole(width - bolt_size, height - bolt_size, bolt_radius, length);
        }
    }
}

module _end_pcap_hole(x, y, h, bolt_radius) {
    translate([x, y, 0])
        cylinder(h=h, r1=bolt_radius, r2=bolt_radius, $fn = 20);
}

module pcb_enclosure_end_cap(pcb_width, pcb_height, pcb_thickness=1.6,
                             pcb_clearance=0.2, wall_thickness=2, bolt_size=2,
                             bolt_hole_ratio=1.1) {
    pcb_height_bottom = (bolt_size * 2) - wall_thickness;
    width = pcb_width + pcb_clearance + (2 * wall_thickness);
    height = pcb_height + pcb_height_bottom + pcb_clearance + pcb_thickness + (2 * wall_thickness);
    bolt_radius = (bolt_size * bolt_hole_ratio) / 2;

    difference() {
        cube([width, height, wall_thickness]);
        _end_pcap_hole(bolt_size, bolt_size, wall_thickness, bolt_radius);
        _end_pcap_hole(bolt_size, height - bolt_size, wall_thickness, bolt_radius);
        _end_pcap_hole(width - bolt_size, bolt_size, wall_thickness, bolt_radius);
        _end_pcap_hole(width - bolt_size, height - bolt_size, wall_thickness, bolt_radius);
    }
}