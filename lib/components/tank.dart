import 'dart:math';
import 'dart:ui';
import 'package:lame_tank_360/lame-tank-360.dart';

/// create by crius on 2021/4/8
/// email:criusker@163.com

class Tank {
  final LameTank360 game;
  Offset position = Offset.zero;
  double bodyAngle = 0;
  double turretAngle = 0;

  double targetBodyAngle;
  double targetTurretAngle;

  Tank(this.game, {this.position});

  void render(Canvas c) {
    // 准备Paint对象
    Paint lightPaint = Paint()..color = Color(0xffdddddd);
    Paint darkPaint = Paint()..color = Color(0xff777777);

    // 将canvas的原点设置在坦克的坐标上
    c.save();
    c.translate(position.dx, position.dy);

    // 旋转坦克主体
    c.rotate(bodyAngle);

    // 绘制坦克主体
    c.drawRect(
      Rect.fromLTWH(-20, -15, 40, 30),
      lightPaint,
    );

    // 绘制轮子
    c.drawRect(
      Rect.fromLTWH(-24, -23, 48, 8),
      darkPaint,
    );
    c.drawRect(
      Rect.fromLTWH(-24, 15, 48, 8),
      darkPaint,
    );
    // 旋转炮台
    c.rotate(turretAngle);

    // 绘制炮塔
    c.drawRect(
      Rect.fromLTWH(-10, -12, 25, 24),
      darkPaint,
    );
    c.drawRect(
      Rect.fromLTWH(0, -3, 36, 6),
      darkPaint,
    );
    c.drawRect(
      Rect.fromLTWH(36, -5, 6, 10),
      darkPaint,
    );

    c.restore();
  }

  void update(double t) {
    print("坦克更新：主体角度：$targetBodyAngle------$bodyAngle-----炮台角度：$targetTurretAngle");
    final double rotationRate = pi * t;
    //  计算主体角度
    if (targetBodyAngle != null) {
      // 直线运动
      if (bodyAngle == targetBodyAngle) {
        position = position + Offset.fromDirection(bodyAngle, 100 * t);
      } else {
        position = position + Offset.fromDirection(bodyAngle, 50 * t);
      }

      if (bodyAngle < targetBodyAngle) {
        if ((targetBodyAngle - bodyAngle).abs() > pi) {
          bodyAngle = bodyAngle - rotationRate;
          if (bodyAngle < -pi) {
            bodyAngle += pi * 2;
          }
        } else {
          bodyAngle = bodyAngle + rotationRate;
        if (bodyAngle > targetBodyAngle) {
          bodyAngle = targetBodyAngle;
        }
      }
      }
      if (bodyAngle > targetBodyAngle) {
        if ((targetBodyAngle - bodyAngle).abs() > pi) {
          bodyAngle = bodyAngle + rotationRate;
          if (bodyAngle > pi) {
            bodyAngle -= pi * 2;
          }
        } else {
          bodyAngle = bodyAngle - rotationRate;
          if (bodyAngle < targetBodyAngle) {
            bodyAngle = targetBodyAngle;
          }
        }
      }
    }
    // 计算炮台角度
    if (targetTurretAngle != null) {
      double localTargetTurretAngle = targetTurretAngle - bodyAngle;
      if (turretAngle < localTargetTurretAngle) {
        if ((localTargetTurretAngle - turretAngle).abs() > pi) {
          turretAngle = turretAngle - rotationRate;
          if (turretAngle < -pi) {
            turretAngle += pi * 2;
          }
        } else {
          turretAngle = turretAngle + rotationRate;
          if (turretAngle > localTargetTurretAngle) {
            turretAngle = localTargetTurretAngle;
          }
        }
      }
      if (turretAngle > localTargetTurretAngle) {
        if ((localTargetTurretAngle - turretAngle).abs() > pi) {
          turretAngle = turretAngle + rotationRate;
          if (turretAngle > pi) {
            turretAngle -= pi * 2;
          }
        } else {
          turretAngle = turretAngle - rotationRate;
          if (turretAngle < localTargetTurretAngle) {
            turretAngle = localTargetTurretAngle;
          }
        }
      }
    }
  }

  Offset getBulletOffset() {
    return position +
        Offset.fromDirection(
          getBulletAngle(),
          36,
        );
  }

  double getBulletAngle() {
    double bulletAngle = bodyAngle + turretAngle;
    while (bulletAngle > pi) {
      bulletAngle -= pi * 2;
    }
    while (bulletAngle < -pi) {
      bulletAngle += pi * 2;
    }
    return bulletAngle;
  }
}