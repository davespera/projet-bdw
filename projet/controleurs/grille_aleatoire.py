import random

def generate_grid(width, height):
    grid = [[' ' for _ in range(width)] for _ in range(height)]
    num_targets = random.randint(int(0.1 * width * height), int(0.2 * width * height))

    def is_valid(x, y):
        return 0 <= x < height and 0 <= y < width and grid[x][y] == ' '

    directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    targets = []

    x, y = random.randint(0, height - 1), random.randint(0, width - 1)
    grid[x][y] = 'T'
    targets.append((x, y))

    while len(targets) < num_targets:
        tx, ty = random.choice(targets)
        random.shuffle(directions)
        for dx, dy in directions:
            nx, ny = tx + dx, ty + dy
            if is_valid(nx, ny):
                grid[nx][ny] = 'T'
                targets.append((nx, ny))
                break

    return grid

if 'width' in POST and 'height' in POST:
    width = int(POST['width'][0])
    height = int(POST['height'][0])
    grid = generate_grid(width, height)
    REQUEST_VARS['grid'] = grid
else:
    REQUEST_VARS['grid'] = Noneproposées