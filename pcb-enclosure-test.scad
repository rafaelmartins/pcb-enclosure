include <pcb-enclosure.scad>

pcb_length = 76.7;
pcb_width = 41.5;
pcb_height = 18;
pcb_thickness = 1.6;
pcb_clearance = 0.2;
pcb_holder_size = 1;
wall_thickness = 1.5;
foot_margin = 5;
foot_radius = 4;
bolt_size = 2;
bolt_hole_ratio_body = 0.95;
bolt_hole_ratio_end_cap = 1.1;

rotate([90, 0, 90]) {
    pcb_enclosure_end_cap(pcb_width, pcb_height, pcb_thickness, pcb_clearance,
                          wall_thickness, bolt_size, bolt_hole_ratio_end_cap);
    translate([0, 0, wall_thickness])
        pcb_enclosure_body(pcb_length, pcb_width, pcb_height, pcb_thickness,
                           pcb_clearance, pcb_holder_size, wall_thickness,
                           foot_margin, foot_radius, bolt_size,
                           bolt_hole_ratio_body);
    translate([0, 0, pcb_length + wall_thickness])
        pcb_enclosure_end_cap(pcb_width, pcb_height, pcb_thickness,
                              pcb_clearance, wall_thickness, bolt_size,
                              bolt_hole_ratio_end_cap);
}
