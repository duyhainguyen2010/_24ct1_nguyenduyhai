const fs = require('fs');

const config = JSON.parse(
  fs.readFileSync('C:/Users/Laptop T&T/.config/configstore/firebase-tools.json', 'utf8')
);
const token = config.tokens.access_token;
const projectId = 'tim-tro-duyhai-2026';
const database = '(default)';

const mockRooms = [
  {
    id: 'bh-001',
    title: 'Phòng trọ cao cấp gần ĐH Sư Phạm - ĐH Bách Khoa',
    monthlyPrice: 2500000,
    address: '48 Cao Thắng, Q. Hải Châu, Đà Nẵng',
    area: 25.0,
    imageUrl: null,
    isFeatured: true,
    isAvailable: true,
    createdAt: new Date(Date.now() - 4 * 3600 * 1000).toISOString(),
    latitude: 16.0754,
    longitude: 108.2198,
    mockDistanceKm: 0.6,
    description: 'Phòng trọ mới xây sạch đẹp, thoáng mát, ban công đón gió tự nhiên. Nằm trong khu vực an ninh yên tĩnh, gần chợ, siêu thị và các trường đại học lớn. Giờ giấc tự do, không chung chủ.',
    amenities: ['wifi', 'airConditioner', 'parking', 'privateBathroom', 'washingMachine', 'securityCamera'],
    ownerName: 'Cô Nguyễn Thị Mai',
    ownerPhone: '0905 888 999',
  },
  {
    id: 'bh-002',
    title: 'Phòng khép kín full nội thất, máy lạnh, ban công thoáng mát',
    monthlyPrice: 3200000,
    address: '120 Nguyễn Lương Bằng, Q. Liên Chiểu, Đà Nẵng',
    area: 30.0,
    imageUrl: null,
    isFeatured: true,
    isAvailable: true,
    createdAt: new Date(Date.now() - 12 * 3600 * 1000).toISOString(),
    latitude: 16.0682,
    longitude: 108.1567,
    mockDistanceKm: 1.2,
    description: 'Căn hộ mini đầy đủ tiện nghi: giường nệm cao cấp, tủ quần áo, bàn học, máy lạnh Inverter tiết kiệm điện. Khóa cổng vân tay hiện đại, đảm bảo an toàn tuyệt đối.',
    amenities: ['wifi', 'airConditioner', 'parking', 'privateBathroom', 'kitchen', 'refrigerator', 'securityCamera'],
    ownerName: 'Chú Trần Văn Đức',
    ownerPhone: '0935 112 233',
  },
  {
    id: 'bh-003',
    title: 'Studio mini sinh viên có gác lửng, giờ giấc tự do',
    monthlyPrice: 1900000,
    address: '15 Ngô Sĩ Liên, Q. Liên Chiểu, Đà Nẵng',
    area: 20.0,
    imageUrl: null,
    isFeatured: true,
    isAvailable: true,
    createdAt: new Date(Date.now() - 24 * 3600 * 1000).toISOString(),
    latitude: 16.0712,
    longitude: 108.1534,
    mockDistanceKm: 0.9,
    description: 'Phòng có gác lửng đúc kiên cố, ốp gạch men sạch sẽ từ sàn tới trần. Phù hợp cho 1-2 bạn sinh viên ở ghép tiết kiệm chi phí. Điện nước tính theo công tơ riêng giá nhà nước.',
    amenities: ['wifi', 'parking', 'privateBathroom', 'securityCamera'],
    ownerName: 'Anh Lê Hoàng Quân',
    ownerPhone: '0914 445 566',
  },
  {
    id: 'bh-004',
    title: 'Phòng trọ mới xây, có camera an ninh, nhà để xe rộng rãi',
    monthlyPrice: 1800000,
    address: '88 Tôn Đức Thắng, Q. Cẩm Lệ, Đà Nẵng',
    area: 18.0,
    imageUrl: null,
    isFeatured: false,
    isAvailable: false,
    createdAt: new Date(Date.now() - 48 * 3600 * 1000).toISOString(),
    latitude: 16.0421,
    longitude: 108.1812,
    mockDistanceKm: 1.5,
    description: 'Phòng trọ khu vực trung tâm Cẩm Lệ, giao thông thuận tiện. Nhà trọ vừa hết phòng trong tháng này, quý khách vui lòng liên hệ trước để đặt chỗ cho tháng sau.',
    amenities: ['wifi', 'parking', 'privateBathroom', 'securityCamera'],
    ownerName: 'Bác Phạm Văn Hùng',
    ownerPhone: '0903 777 888',
  },
  {
    id: 'bh-005',
    title: 'Chung cư mini 1 phòng ngủ, bếp riêng, máy giặt chung',
    monthlyPrice: 3500000,
    address: '24 Núi Thành, Q. Hải Châu, Đà Nẵng',
    area: 35.0,
    imageUrl: null,
    isFeatured: true,
    isAvailable: true,
    createdAt: new Date(Date.now() - 53 * 3600 * 1000).toISOString(),
    latitude: 16.0598,
    longitude: 108.2215,
    mockDistanceKm: 2.1,
    description: 'Chung cư mini cao cấp có thang máy, khu giặt phơi trên sân thượng có mái che. Phòng ngủ tách biệt với phòng khách và bếp, view nhìn thẳng ra đường lớn.',
    amenities: ['wifi', 'airConditioner', 'parking', 'washingMachine', 'privateBathroom', 'kitchen', 'refrigerator', 'securityCamera'],
    ownerName: 'Chị Đặng Thu Hà',
    ownerPhone: '0978 223 344',
  },
  {
    id: 'bh-006',
    title: 'Phòng trọ giá rẻ cho sinh viên năm nhất, gần bến xe',
    monthlyPrice: 1500000,
    address: '52 Nam Trân, Q. Liên Chiểu, Đà Nẵng',
    area: 16.0,
    imageUrl: null,
    isFeatured: false,
    isAvailable: true,
    createdAt: new Date(Date.now() - 72 * 3600 * 1000).toISOString(),
    latitude: 16.0645,
    longitude: 108.1712,
    mockDistanceKm: 0.8,
    description: 'Phòng trọ bình dân thoáng mát, chủ nhà thân thiện tốt bụng thường xuyên hỗ trợ các bạn tân sinh viên. Nước sinh hoạt máy lạnh và giếng khoan dự phòng.',
    amenities: ['wifi', 'parking', 'privateBathroom'],
    ownerName: 'Cô Bùi Thị Lan',
    ownerPhone: '0989 334 455',
  },
  {
    id: 'bh-007',
    title: 'Phòng trọ an ninh, sạch sẽ, có sân phơi chung tầng thượng',
    monthlyPrice: 2200000,
    address: '33 Dũng Sĩ Thanh Khê, Q. Thanh Khê, Đà Nẵng',
    area: 22.0,
    imageUrl: null,
    isFeatured: false,
    isAvailable: true,
    createdAt: new Date(Date.now() - 96 * 3600 * 1000).toISOString(),
    latitude: 16.0699,
    longitude: 108.1856,
    mockDistanceKm: 1.8,
    description: 'Nhà trọ 3 tầng xây mới, hành lang rộng rãi, ban công view biển Thanh Khê mát rượi. Đầy đủ tiện ích cơ bản cho sinh viên và người đi làm.',
    amenities: ['wifi', 'airConditioner', 'parking', 'privateBathroom', 'securityCamera'],
    ownerName: 'Chú Hoàng Văn Nam',
    ownerPhone: '0905 667 788',
  },
];

function toFirestoreFields(room) {
  return {
    title: { stringValue: room.title },
    monthlyPrice: { doubleValue: room.monthlyPrice },
    address: { stringValue: room.address },
    area: { doubleValue: room.area },
    ...(room.imageUrl ? { imageUrl: { stringValue: room.imageUrl } } : { imageUrl: { nullValue: null } }),
    isFeatured: { booleanValue: room.isFeatured },
    isAvailable: { booleanValue: room.isAvailable },
    createdAt: { timestampValue: room.createdAt },
    latitude: { doubleValue: room.latitude },
    longitude: { doubleValue: room.longitude },
    mockDistanceKm: { doubleValue: room.mockDistanceKm },
    description: { stringValue: room.description },
    amenities: {
      arrayValue: {
        values: room.amenities.map(a => ({ stringValue: a }))
      }
    },
    ownerName: { stringValue: room.ownerName },
    ownerPhone: { stringValue: room.ownerPhone }
  };
}

async function seed() {
  console.log('Checking existing rooms in Firestore...');
  const listUrl = `https://firestore.googleapis.com/v1/projects/${projectId}/databases/${database}/documents/rooms?pageSize=1`;
  const listRes = await fetch(listUrl, { headers: { Authorization: `Bearer ${token}` } });
  const listData = await listRes.json();

  if (listData.documents && listData.documents.length > 0) {
    console.log('Collection "rooms" already contains documents. Aborting to avoid duplicates.');
    console.log('Found:', listData.documents.length, 'document(s).');
    return;
  }

  console.log(`Seeding ${mockRooms.length} mock rooms...`);
  for (const room of mockRooms) {
    const url = `https://firestore.googleapis.com/v1/projects/${projectId}/databases/${database}/documents/rooms/${room.id}`;
    const res = await fetch(url, {
      method: 'PATCH',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ fields: toFirestoreFields(room) })
    });
    if (!res.ok) {
      const err = await res.text();
      console.error(`Failed to seed ${room.id}:`, err);
    } else {
      console.log(`✓ Seeded ${room.id} (${room.title.substring(0, 30)}...)`);
    }
  }
  console.log('Seeding completed successfully!');
}

seed().catch(console.error);
