from random import random, randrange
from datetime import datetime, timedelta


FIRST_NAMES = ('Abdul', 'David', 'Julia', 'Arnold', 'Bernhard', 'Gerald', 'Anna', 'Yussef', 'Itziar', 'Olivia', 'Emma', 'Amelia', 'Mia', 'Chloe', 'Penelope', 'Grace', 'Layla', 'Ella', 'Abigail', 'Camila', 'Gianna', 'Evelyn', 'Aaliyah', 'Naomi', 'Aarya', 'Araceli', 'Yamileth', 'Loretta', 'Liam', 'Noah', 'William', 'Lucas', 'Benjamin', 'Marc', 'Oriol', 'Arturo', 'Keith', 'Zain', 'Johann', 'Nikolas', 'Ahmed')

LAST_NAMES = ('Smith', 'Blanc', 'Müller', 'Miller', 'Muller', 'Griesebner', 'Hutticher', 'Karnasiotti', 'Martí', 'Vidal', 'Masferrer', 'Doe', 'Adams', 'Anniston', 'Hunter', 'Swcharzenegger', 'White', 'Black', 'Green', 'Schumacher', 'Perez', 'Fiedler', "O''Connor", "McDonald", 'Johnson', 'Williams', 'Brown', 'Garcia', 'Jones', 'Davis', 'Wilson', 'Moore', 'Jackson', 'Lee', 'Ali', 'Ahmas', 'Sanchez', 'Clark', 'Hill', 'Young', 'Wright', 'Lewis', 'Nguyen', 'Allen')


def rand(options):
    """Pick an item randomly."""
    index = int(random() * len(options))
    return options[index]


def composed_name(prefix=FIRST_NAMES, suffix=LAST_NAMES):
    """Return a random name."""
    return rand(prefix) + ' ' + rand(suffix)


def date(start=None, end=None):
    """Return a random date after start."""
    start_date = datetime.strptime(start, '%Y-%M-%d')
    if not end:
        end_date = datetime.now()
    else:
        end_date = end
    time_between_dates = end_date - start_date
    days_between_dates = int(time_between_dates.total_seconds())
    random_number_of_days = randrange(days_between_dates)
    random_date = start_date + timedelta(seconds=random_number_of_days)
    return random_date


def rand_integer(min=0, max=10000):
    """Return a random integer."""
    return randrange(max - min) + min


def fk(total, null=True):
    """Return a random foreign key."""
    _id = randrange(total)
    if _id == 0:
        if null:
            return "NULL"
        return _id + 1
    return _id


num_facilities = 9
# members
table = 'member'
sql = f"INSERT INTO {table}(name, join_date, recommended_by, balance) VALUES\n"
num_members = 84

for i in range(0, num_members):
    name = composed_name(FIRST_NAMES, LAST_NAMES)
    join_date = date(start='2019-08-10')
    balance = rand_integer(min=10, max=200)
    if random() > 0.75:
        recommended_by = randrange(num_members)
    else:
        recommended_by = "NULL"
    sql = sql + f"\t('{name}', '{join_date}', {recommended_by}, {balance})"
    if i < num_members - 1:
        sql = sql + ",\n"
    else:
        sql = sql + ";"
print(sql)

# booking
table = 'booking'
sql = f"INSERT INTO {table}(facility_id, member_id, start_time, slots) VALUES\n"
num_bookings = 696
for i in range(0, num_bookings):
    facility = rand_integer(min=1, max=num_facilities)
    member = rand_integer(min=1, max=num_members)
    start = date(start='2019-08-17')
    slots = rand_integer(min=1, max=3)
    sql = sql + f"\t({facility}, {member}, '{start}', {slots})"
    if i < num_bookings - 1:
        sql = sql + ",\n"
    else:
        sql = sql + ";"
print(sql)
