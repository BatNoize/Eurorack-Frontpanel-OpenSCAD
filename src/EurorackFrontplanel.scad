// Module width according to Doepfer standard up to 42 HP https://doepfer.de/a100_man/a100m_d.htm
// Module height 1U according to Intellijel https://intellijel.com/support/1u-technical-specifications/

/* [ Eurorack Settings ] */
// Width of the module in HP (Horizontal Pitch)
module_hp = 8; // [1, 1.5, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 21, 22, 24, 28, 42, 84]
// Height of the module in U (Rack Units)
module_u = 3; // [3, 1]

// Height lookup table: [U, Height in mm]
eurorack_u_data = [
    [3, 128.5],
    [1, 39.65]
];

// Width lookup table: [HP, Rounded Width in mm]
eurorack_data = [
    [1,    5.0],
    [1.5,  7.5],
    [2,    9.8],
    [4,    20.0],
    [6,    30.0],
    [8,    40.3],
    [10,   50.5],
    [12,   60.6],
    [14,   70.8],
    [16,   80.9],
    [18,   91.3],
    [20,   101.3],
    [21,   106.3],
    [22,   111.4],
    [24,   121.9],
    [28,   141.9],
    [42,   213.0],
    [84,   426.7]
];

/* [ Slot/Panel Settings ] */
// Slot rounding diameter
slot_width = 3.4;
// Total length excluding rounded ends
slot_length = 2.54;
// Horizontal offset from side for multi-slot configurations
margin_x = 7.5;
// Standard vertical offset for Eurorack screws
margin_y = 3.0;
// Material thickness
panel_thickness = 2.0;

// Functions for dimension lookups
function get_eurorack_width(hp) = lookup(hp, eurorack_data);
function get_eurorack_height(u) = lookup(u, eurorack_u_data);

// Calculate current dimensions
current_width = get_eurorack_width(module_hp);
current_height = get_eurorack_height(module_u);

// Module for a single mounting slot
module slot(x, y) {
    translate([x, y, 0]) {
        hull() {
            translate([-(slot_length/2), 0, 0])
                cylinder(d = slot_width, h = panel_thickness + 5, center = true, $fn = 50);
            
            translate([(slot_length/2), 0, 0])
                cylinder(d = slot_width, h = panel_thickness + 5, center = true, $fn = 50);
        }
    }
}

// Main module for the front panel with conditional slot placement
module front_panel_with_slots() {
    
    difference() {
        // Base plate
        cube([current_width, current_height, panel_thickness]);
        
        // Subtract slots based on module width
        if (module_hp <= 2) {
            // Single slot top and bottom (centered horizontally)
            slot(current_width / 2, margin_y);
            slot(current_width / 2, current_height - margin_y);
        }
        else if (module_hp <= 4) {
            // Single slot top and bottom (aligned to margin_x)
            slot(margin_x, margin_y);
            slot(margin_x, current_height - margin_y);
        }
        else {
            // Two slots top and bottom with specified horizontal margin
            // Bottom edge
            slot(margin_x, margin_y);
            slot(current_width - margin_x, margin_y);
            
            // Top edge
            slot(margin_x, current_height - margin_y);
            slot(current_width - margin_x, current_height - margin_y);
        }
    }
}

// Render the front panel
front_panel_with_slots();

// Console output for verification
echo(str("Module HP: ", module_hp));
echo(str("Module U: ", module_u));
echo(str("Calculated Width: ", current_width, " mm"));
echo(str("Calculated Height: ", current_height, " mm"));
echo(str("Slots per edge: ", (module_hp <= 4 ? "1" : "2")));