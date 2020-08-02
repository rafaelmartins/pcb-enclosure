include <pcb-enclosure.scad>

translate([2, 0, 0])
    pcb_enclosure_body(76.7, 41.5, 18);
translate([0, 0, 1.5]) {
    rotate([90, 0, 90]) {
        pcb_enclosure_end_cap(41.5, 18);
        translate([0, 0, 78.7])
            pcb_enclosure_end_cap(41.5, 18);
    }
}