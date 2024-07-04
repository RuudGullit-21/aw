
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Параметры.Свойство("АдресОтправления", АдресОтправления);
	Параметры.Свойство("АдресНазначения",  АдресНазначения);
	Параметры.Свойство("Грузоотправитель", Грузоотправитель);
	Параметры.Свойство("Грузополучатель",  Грузополучатель);
	Параметры.Свойство("Маршрут",          Маршрут);
	Параметры.Свойство("НачалоПериода",    НачалоПериода);
	Параметры.Свойство("КонецПериода",     КонецПериода);
	Если Не ЗначениеЗаполнено(НачалоПериода) Тогда
		НачалоПериода = НачалоДня(ТекущаяДатаСеанса());
	КонецЕсли;
	Если Не ЗначениеЗаполнено(КонецПериода) Тогда
		// По умолчанию получаем расписание на 1 неделю
		СекундВШестиСутках = 6*24*60*60;
		КонецПериода = НачалоПериода + СекундВШестиСутках;
	КонецЕсли;
	
	Элементы.Отправление.Заголовок = Строка(АдресОтправления);
	Элементы.Прибытие.Заголовок    = Строка(АдресНазначения);
	
	СформироватьТаблицуРасписания();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	СформироватьТаблицуРасписания();
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	СформироватьТаблицуРасписания();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРасписание

&НаКлиенте
Процедура РасписаниеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	// Обработка нажатия на гиперссылку "Выбрать дату" из строки таблицы
	Если Поле <> Элементы.РасписаниеВыбратьДату Тогда
		Возврат;
	КонецЕсли;
	ТекущиеДанные = Элементы.Расписание.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		РезультатЗакрытия = Новый Структура("ДатаОтправления, ДатаПрибытия, FTL, ВремяОтправленияС, ВремяОтправленияПо,
			|ВремяПрибытияС, ВремяПрибытияПо, Выход, Рейс, ДатаУстановки, ДействуетС, ДействуетПо");
		ЗаполнитьЗначенияСвойств(РезультатЗакрытия, ТекущиеДанные);
		РезультатЗакрытия.ВремяОтправленияС = ТекущиеДанные.ВремяОтправленияС;
		РезультатЗакрытия.ВремяОтправленияПо = ТекущиеДанные.ВремяОтправленияПо;
		РезультатЗакрытия.ВремяПрибытияС = ТекущиеДанные.ВремяПрибытияС;
		РезультатЗакрытия.ВремяПрибытияПо = ТекущиеДанные.ВремяПрибытияПо;
		Закрыть(РезультатЗакрытия);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьРасписание(Команда)
	СформироватьТаблицуРасписания();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьТаблицуРасписания()
	
	Расписание.Очистить();
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	ИначеЕсли НачалоПериода > КонецПериода Тогда
		ТекстНСтр = НСтр("ru='Неправильно заполнен период. Дата окончания периода должна быть больше, чем дата начала';
			|en='Period end date must be greater than period start date'");
		ОбщегоНазначения.СообщитьПользователю(ТекстНСтр);
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура("Маршрут, АдресОтправления, АдресНазначения, Грузоотправитель, Грузополучатель");
	СтруктураПараметров.Маршрут = Маршрут;
	СтруктураПараметров.АдресОтправления = АдресОтправления;
	СтруктураПараметров.АдресНазначения = АдресНазначения;
	СтруктураПараметров.Грузоотправитель = Грузоотправитель;
	СтруктураПараметров.Грузополучатель = Грузополучатель;
	ПодходящиеРейсы = уатОбщегоНазначения_уэ.ДанныеРасписания(НачалоПериода, КонецПериода, СтруктураПараметров);
	
	Для Каждого ТекСтрока Из ПодходящиеРейсы Цикл
		НоваяСтрока = Расписание.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
		НоваяСтрока.ВремяПрибытияС = ТекСтрока.ПрибытиеС;
		НоваяСтрока.ВремяПрибытияПо = ТекСтрока.ПрибытиеПо;
		НоваяСтрока.ВремяОтправленияС = ТекСтрока.ОтправлениеС;
		НоваяСтрока.ВремяОтправленияПо = ТекСтрока.ОтправлениеПо;
		НоваяСтрока.ДеньНеделиУбытия = ПредставлениеДняНедели(ДеньНедели(НоваяСтрока.ДатаОтправления));
		НоваяСтрока.ДеньНеделиПрибытия = ПредставлениеДняНедели(ДеньНедели(НоваяСтрока.ДатаПрибытия));
		НоваяСтрока.ВыбратьДату = НСтр("ru='Выбрать дату'");
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПредставлениеДняНедели(НомерДняНедели)

	Если НомерДняНедели = 1 Тогда
		Результат = НСтр("ru='Пн';en='Mon'");
	ИначеЕсли НомерДняНедели = 2 Тогда
		Результат = НСтр("ru='Вт';en='Tue'");
	ИначеЕсли НомерДняНедели = 3 Тогда
		Результат = НСтр("ru='Ср';en='Wed'");
	ИначеЕсли НомерДняНедели = 4 Тогда
		Результат = НСтр("ru='Чт';en='Thu'");
	ИначеЕсли НомерДняНедели = 5 Тогда
		Результат = НСтр("ru='Пт';en='Fri'");
	ИначеЕсли НомерДняНедели = 6 Тогда
		Результат = НСтр("ru='Сб';en='Sat'");
	ИначеЕсли НомерДняНедели = 7 Тогда
		Результат = НСтр("ru='Вс';en='Sun'");
	Иначе
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Неопределено (%1)';en='Undefined (%1)'"),
			НомерДняНедели);
	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти