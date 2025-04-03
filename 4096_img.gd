extends Control

# UI elements
@onready var texture_rect = $HBoxContainer/VBoxContainer/TextureRect
@onready var encoded_label = $HBoxContainer/RichTextLabel
@onready var input_label = $HBoxContainer/TextEdit

# Image and encoding data
var original_image = []
var unicode_chars = []

func _ready():
	generate_unicode_chars()

###### BEGIN Main Part of Code

# Picked unicode characters kind of at random to make it look more interesting. \
# My intent is also to have avoided any characters that could directly come \
# across as offensive (symbols, words), but I may have missed some.
func generate_unicode_chars():
	var ranges = [
		[0x0041, 0x007B],  # A-Z, a-z
		[0x0391, 0x03AA],  # Greek uppercase
		[0x0410, 0x0450],  # Cyrillic
		[0x2200, 0x2300],  # Mathematical operators
		[0x2500, 0x2580],  # Box drawing
		[0x0900, 0x097F],  # Devanagari
		[0x0E00, 0x0E7F],  # Thai
		[0x3400, 0x4DC0],  # CJK Extension A
	]
	
	for range_pair in ranges:
		for i in range(range_pair[0], range_pair[1]):
			unicode_chars.append(char(i))
	
	assert(len(unicode_chars) >= 4096)
	unicode_chars = unicode_chars.slice(0, 4096)

# Helper function to convert a Unicode code point to a character
func char(code):
	return PackedByteArray([code >> 8, code & 0xFF]).get_string_from_utf16()

# Converts the image array into a base4096 string.
func image_to_string(image):
	var flattened = []
	for row in image:
		flattened.append_array(row)
	
	# Pad the flattened array to make its length a multiple of 3
	while len(flattened) % 3 != 0:
		flattened.append(0)  # Pad with zeros
	
	var combined = []
	for i in range(0, len(flattened), 3):
		var value = (flattened[i] << 8) | (flattened[i+1] << 4) | flattened[i+2]
		combined.append(unicode_chars[value])
	
	var result = ""
	for char in combined:
		result += char
	return result

# Converts the base4096 string back into an image array.
func string_to_image(s):
	var combined = []
	for char in s:
		combined.append(unicode_chars.find(char))
	
	var flattened = []
	for value in combined:
		flattened.append((value >> 8) & 0xF)  # First pixel
		flattened.append((value >> 4) & 0xF)   # Second pixel
		flattened.append(value & 0xF)          # Third pixel
	
	# Remove padding zeros added during encoding
	while len(flattened) > 32 * 32:
		flattened.pop_back()
	
	var image = []
	for i in range(0, len(flattened), 32):
		image.append(flattened.slice(i, i + 32))
	
	return image

###### END Main Part of Code

# Display image
func display_image(image_data):
	var image = Image.create(32, 32, false, Image.FORMAT_RGB8)
	for y in range(32):
		for x in range(32):
			var color_value = image_data[y][x] * 16  # Scale to 0-255
			image.set_pixel(x, y, Color(color_value / 255.0, color_value / 255.0, color_value / 255.0))
	
	var texture = ImageTexture.create_from_image(image)
	texture_rect.texture = texture

## Two gradients are flip flopped between, exists as contrast to noise.
var example_img = false
func generate_example_image():
	example_img = !example_img
	
	if example_img:
		var image = []
		for y in range(32):
			var row = []
			for x in range(32):
				var value = int((x / 31.0) * 15)
				row.append(value)
			image.append(row)
		return image
	else:
		var image = []
		for x in range(32):
			var row = []
			for y in range(32):
				var value = int((x / 31.0) * 15)
				row.append(value)
			image.append(row)
		return image

### Buttons

# Show one of two gradients.
func _on_example_pressed():
	original_image = generate_example_image()
	display_image(original_image)
	var encoded_string = image_to_string(original_image)
	encoded_label.text = encoded_string

# Random noise image generation for example.
func _on_generate_pressed():
	original_image = []
	for i in range(32):
		var row = []
		for j in range(32):
			row.append(randi() % 16)
		original_image.append(row)
	
	display_image(original_image)
	
	var encoded_string = image_to_string(original_image)
	encoded_label.text = encoded_string

# Perform decode from base4096 using TextEdit entry.
func _on_decode_pressed():
	var input_string = input_label.text
	if input_string.length() <= 10:
		return
	var reconstructed_image = string_to_image(input_string)
	display_image(reconstructed_image)
