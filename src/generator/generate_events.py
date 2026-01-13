import uuid
import random
from datetime import datetime, timedelta

EVENT_TYPES = [
    "page_view",
    "product_view",
    "add_to_cart",
    "checkout_start",
    "purchase"
]

DEVICE_TYPES = ["mobile", "desktop"]
TRAFFIC_SOURCES = ["organic", "paid_search", "email", "social"]

PRODUCT_CATALOG = [
    {"product_id": 1, "category": "filters", "price": 29.99},
    {"product_id": 2, "category": "filters", "price": 39.99},
    {"product_id": 3, "category": "accessories", "price": 9.99},
]

def generate_session(user_id, start_time):
    session_id = uuid.uuid4()
    events = []

    current_time = start_time

    device = random.choice(DEVICE_TYPES)
    traffic = random.choice(TRAFFIC_SOURCES)

    # Page view (always happens)
    events.append({
        "event_id": uuid.uuid4(),
        "event_type": "page_view",
        "event_timestamp": current_time,
        "user_id": user_id,
        "session_id": session_id,
        "page_url": "/",
        "product_id": None,
        "category": None,
        "price": None,
        "quantity": None,
        "device_type": device,
        "traffic_source": traffic
    })

    # Maybe view a product
    if random.random() < 0.7:
        product = random.choice(PRODUCT_CATALOG)
        current_time += timedelta(seconds=random.randint(10, 60))

        events.append({
            "event_id": uuid.uuid4(),
            "event_type": "product_view",
            "event_timestamp": current_time,
            "user_id": user_id,
            "session_id": session_id,
            "page_url": f"/products/{product['product_id']}",
            "product_id": product["product_id"],
            "category": product["category"],
            "price": None,
            "quantity": None,
            "device_type": device,
            "traffic_source": traffic
        })

        # Maybe add to cart
        if random.random() < 0.4:
            current_time += timedelta(seconds=random.randint(5, 30))

            events.append({
                "event_id": uuid.uuid4(),
                "event_type": "add_to_cart",
                "event_timestamp": current_time,
                "user_id": user_id,
                "session_id": session_id,
                "page_url": "/cart",
                "product_id": product["product_id"],
                "category": product["category"],
                "price": product["price"],
                "quantity": 1,
                "device_type": device,
                "traffic_source": traffic
            })

            # Maybe purchase
            if random.random() < 0.3:
                current_time += timedelta(seconds=random.randint(10, 60))

                events.append({
                    "event_id": uuid.uuid4(),
                    "event_type": "purchase",
                    "event_timestamp": current_time,
                    "user_id": user_id,
                    "session_id": session_id,
                    "page_url": "/checkout/complete",
                    "product_id": product["product_id"],
                    "category": product["category"],
                    "price": product["price"],
                    "quantity": 1,
                    "device_type": device,
                    "traffic_source": traffic
                })

    return events

def generate_events(num_users=100, sessions_per_user=5):
    all_events = []
    base_time = datetime.now() - timedelta(days=7)

    for user_id in range(1, num_users + 1):
        for _ in range(sessions_per_user):
            session_start = base_time + timedelta(minutes=random.randint(0, 10000))
            session_events = generate_session(user_id, session_start)
            all_events.extend(session_events)

    return all_events

if __name__ == "__main__":
    events = generate_events()
    print(f"Generated {len(events)} events")

    import csv
    import os

    output_path = "data/raw/events.csv"
    os.makedirs("data/raw", exist_ok=True)

    with open(output_path, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=events[0].keys())
        writer.writeheader()
        writer.writerows(events)

    print(f"Wrote CSV to {output_path}")