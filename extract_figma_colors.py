#!/usr/bin/env python3
import json
import sys

def rgb_to_hex(r, g, b):
    """Convert RGB (0-1) to hex"""
    r = int(r * 255)
    g = int(g * 255)
    b = int(b * 255)
    return f"#{r:02x}{g:02x}{b:02x}"

def extract_colors_from_figma():
    with open('/Users/remy/Desktop/works/seouloppa/figma_full_data.json', 'r') as f:
        data = json.load(f)
    
    colors = []
    
    def traverse(obj, path=""):
        if isinstance(obj, dict):
            # Check if this object has fills with color
            if 'fills' in obj and 'name' in obj and obj['fills']:
                for fill in obj['fills']:
                    if 'color' in fill:
                        color = fill['color']
                        hex_color = rgb_to_hex(color['r'], color['g'], color['b'])
                        colors.append({
                            'name': obj['name'],
                            'rgb': color,
                            'hex': hex_color,
                            'opacity': color.get('a', 1.0)
                        })
            
            # Recursively traverse all values
            for key, value in obj.items():
                traverse(value, f"{path}.{key}" if path else key)
        
        elif isinstance(obj, list):
            for i, item in enumerate(obj):
                traverse(item, f"{path}[{i}]" if path else f"[{i}]")
    
    traverse(data)
    
    # Remove duplicates based on hex color
    unique_colors = []
    seen_hex = set()
    for color in colors:
        if color['hex'] not in seen_hex:
            unique_colors.append(color)
            seen_hex.add(color['hex'])
    
    return unique_colors[:50]  # Return first 50 unique colors

if __name__ == "__main__":
    colors = extract_colors_from_figma()
    with open('/Users/remy/Desktop/works/seouloppa/figma_colors_extracted.json', 'w') as f:
        json.dump(colors, f, indent=2, ensure_ascii=False)
    
    print(f"Extracted {len(colors)} unique colors from Figma")