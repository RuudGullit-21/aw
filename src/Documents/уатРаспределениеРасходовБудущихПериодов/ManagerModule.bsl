#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	Настройки.ПриПолученииСлужебныхРеквизитов = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	// необходима для подключения внешних ПФ
	Заглушка = Истина;
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.УправлениеДоступом

// Позволяет переопределить ограничение, указанное в модуле менеджера объекта метаданных.
//
// Параметры:
//  Ограничение - Структура:
//    * Текст                             - Строка - ограничение доступа для пользователей.
//                                          Если пустая строка, значит, доступ разрешен.
//    * ТекстДляВнешнихПользователей      - Строка - ограничение доступа для внешних пользователей.
//                                          Если пустая строка, значит, доступ запрещен.
//    * ПоВладельцуБезЗаписиКлючейДоступа - Неопределено - определить автоматически.
//                                        - Булево - если Ложь, то всегда записывать ключи доступа,
//                                          если Истина, тогда не записывать ключи доступа,
//                                          а использовать ключи доступа владельца (требуется,
//                                          чтобы ограничение было строго по объекту-владельцу).
//   * ПоВладельцуБезЗаписиКлючейДоступаДляВнешнихПользователей - Неопределено, Булево - также
//                                          как у параметра ПоВладельцуБезЗаписиКлючейДоступа.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Подразделение)";
	
	Ограничение.ТекстДляВнешнихПользователей = Ограничение.Текст;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатРаспределениеРасходовБудущихПериодовРасходы.Ссылка КАК Регистратор,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.Ссылка.Дата КАК Период,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.Ссылка.Подразделение КАК Подразделение,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.Ссылка.Колонна КАК Колонна,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.СтатьяРБП,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.СтатьяРасходов,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.ТС,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.ОбъектСтроительства,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.Заказ,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.Заказ.Ответственный КАК Менеджер,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.Контрагент,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.Маршрут,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.ВидПеревозки,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.НаправлениеПеревозки,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.Сумма КАК СуммаУпр,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.СуммаРегл,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.СуммаНДС,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.СуммаНДСУпр КАК СуммаНДСУпр,
	|	уатРаспределениеРасходовБудущихПериодовРасходы.Ссылка.Организация КАК Организация
	|ИЗ
	|	Документ.уатРаспределениеРасходовБудущихПериодов.Расходы КАК уатРаспределениеРасходовБудущихПериодовРасходы
	|ГДЕ
	|	уатРаспределениеРасходовБудущихПериодовРасходы.Ссылка = &Документ");
	Запрос.УстановитьПараметр("Документ", ДокументСсылка);
	тблРасходыРБП = Запрос.Выполнить().Выгрузить();
	
	тблРасходы = тблРасходыРБП.Скопировать();
	тблРасходы.Очистить();
	тблРасходы.Колонки.Удалить("СтатьяРБП");
	тблРасходы.Колонки.Добавить("ВидДвижения");
	
	// получаем список периодов распределения
	Если ДокументСсылка.КоличествоМесяцев = 0 Тогда
		ТаблицаПериодов = РазбитьПериодНаПодпериоды(ДокументСсылка.НачалоПериода, ДокументСсылка.КонецПериода);
		ВсегоДней = ТаблицаПериодов.Итог("КоличествоДней");
		КоличПериодов = ТаблицаПериодов.Количество();
		
		Для Каждого ТекСтрокаРБП Из тблРасходыРБП Цикл
			СуммаОсталось       = ТекСтрокаРБП.СуммаУпр;
			СуммаРеглОсталось   = ТекСтрокаРБП.СуммаРегл;
			СуммаНДСОсталось    = ТекСтрокаРБП.СуммаНДС;
			СуммаНДСУпрОсталось = ТекСтрокаРБП.СуммаНДСУпр;
			Сч = 1;
			
			Для Каждого ТекПериод Из ТаблицаПериодов Цикл
				
				// формируем движения по оприходованию по статье расходов
				НоваяСтрока = тблРасходы.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрокаРБП);
				НоваяСтрока.Период = ТекПериод.ДатаНачала;
				НоваяСтрока.СтатьяРасходов = ТекСтрокаРБП.СтатьяРасходов;
				НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Приход;
				
				Если Сч = КоличПериодов Тогда //учет последней копейки
					НоваяСтрока.СуммаУпр    = СуммаОсталось;
					НоваяСтрока.СуммаРегл   = СуммаРеглОсталось;
					НоваяСтрока.СуммаНДС    = СуммаНДСОсталось;
					НоваяСтрока.СуммаНДСУпр = СуммаНДСУпрОсталось;
				Иначе
					НоваяСтрока.СуммаУпр    = ТекСтрокаРБП.СуммаУпр    / ВсегоДней * ТекПериод.КоличествоДней;
					НоваяСтрока.СуммаРегл   = ТекСтрокаРБП.СуммаРегл   / ВсегоДней * ТекПериод.КоличествоДней;
					НоваяСтрока.СуммаНДС    = ТекСтрокаРБП.СуммаНДС    / ВсегоДней * ТекПериод.КоличествоДней;
					НоваяСтрока.СуммаНДСУпр = ТекСтрокаРБП.СуммаНДСУпр / ВсегоДней * ТекПериод.КоличествоДней;
				КонецЕсли;
				
				// формируем движения по расходу по статье РБП
				НоваяСтрокаРасход = тблРасходы.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаРасход, НоваяСтрока);
				НоваяСтрокаРасход.СтатьяРасходов = ТекСтрокаРБП.СтатьяРБП;
				НоваяСтрокаРасход.ВидДвижения    = ВидДвиженияНакопления.Расход;
				
				СуммаОсталось       = СуммаОсталось       - НоваяСтрока.СуммаУпр;
				СуммаРеглОсталось   = СуммаРеглОсталось   - НоваяСтрока.СуммаРегл;
				СуммаНДСОсталось    = СуммаНДСОсталось    - НоваяСтрока.СуммаНДС;
				СуммаНДСУпрОсталось = СуммаНДСУпрОсталось - НоваяСтрока.СуммаНДСУпр;
				
				Сч = Сч + 1;
			КонецЦикла;	
		КонецЦикла;		
	Иначе
		мсвПериоды = Новый Массив;
		ТекДата = НачалоМесяца(ДокументСсылка.НачалоПериода);
		ДокументСсылка_КонецПериода = ДобавитьМесяц(НачалоМесяца(ДокументСсылка.НачалоПериода), ДокументСсылка.КоличествоМесяцев-1);
		Пока ТекДата <= НачалоМесяца(ДокументСсылка_КонецПериода) Цикл
			Если ТекДата = НачалоМесяца(ДокументСсылка.НачалоПериода) Тогда //первую дату распределения указываем НачалоПериода документа
				мсвПериоды.Добавить(ДокументСсылка.НачалоПериода);
			Иначе //остальные даты - начало каждого последующего месяца
				мсвПериоды.Добавить(ТекДата);
			КонецЕсли;
			
			ТекДата = ДобавитьМесяц(ТекДата, 1);
		КонецЦикла;
		КоличПериодов = мсвПериоды.Количество();
		
		// распределение по статьям расходов, соотв. статьям РБП
		Для Каждого ТекСтрокаРБП Из тблРасходыРБП Цикл
			СуммаОсталось       = ТекСтрокаРБП.СуммаУпр;
			СуммаРеглОсталось   = ТекСтрокаРБП.СуммаРегл;
			СуммаНДСОсталось    = ТекСтрокаРБП.СуммаНДС;
			СуммаНДСУпрОсталось = ТекСтрокаРБП.СуммаНДСУпр;
			
			Сч = 1;
			Для Каждого ТекПериод Из мсвПериоды Цикл
				
				// формируем движения по оприходованию по статье расходов
				НоваяСтрока = тблРасходы.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрокаРБП);
				НоваяСтрока.Период = ТекПериод;
				НоваяСтрока.СтатьяРасходов = ТекСтрокаРБП.СтатьяРасходов;
				НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Приход;
				
				Если Сч = КоличПериодов Тогда //учет последней копейки
					НоваяСтрока.СуммаУпр    = СуммаОсталось;
					НоваяСтрока.СуммаРегл   = СуммаРеглОсталось;
					НоваяСтрока.СуммаНДС    = СуммаНДСОсталось;
					НоваяСтрока.СуммаНДСУпр = СуммаНДСУпрОсталось;
				Иначе
					НоваяСтрока.СуммаУпр    = ТекСтрокаРБП.СуммаУпр    / КоличПериодов;
					НоваяСтрока.СуммаРегл   = ТекСтрокаРБП.СуммаРегл   / КоличПериодов;
					НоваяСтрока.СуммаНДС    = ТекСтрокаРБП.СуммаНДС    / КоличПериодов;
					НоваяСтрока.СуммаНДСУпр = ТекСтрокаРБП.СуммаНДСУпр / КоличПериодов;
				КонецЕсли;
				
				// формируем движения по расходу по статье РБП
				НоваяСтрокаРасход = тблРасходы.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаРасход, НоваяСтрока);
				НоваяСтрокаРасход.СтатьяРасходов = ТекСтрокаРБП.СтатьяРБП;
				НоваяСтрокаРасход.ВидДвижения    = ВидДвиженияНакопления.Расход;
				
				СуммаОсталось       = СуммаОсталось       - НоваяСтрока.СуммаУпр;
				СуммаРеглОсталось   = СуммаРеглОсталось   - НоваяСтрока.СуммаРегл;
				СуммаНДСОсталось    = СуммаНДСОсталось    - НоваяСтрока.СуммаНДС;
				СуммаНДСУпрОсталось = СуммаНДСУпрОсталось - НоваяСтрока.СуммаНДСУпр;
				
				Сч = Сч + 1;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
		
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРасходы", тблРасходы);
КонецПроцедуры // ИнициализироватьДанныеДокумента()

Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Заглушка = Истина;
	
КонецПроцедуры

Функция РазбитьПериодНаПодпериоды(Знач ДатаНачала, Знач ДатаОкончания)
	
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ТаблицаЗначений.Колонки.Добавить("ДатаНачала");
	ТаблицаЗначений.Колонки.Добавить("ДатаОкончания");
	ТаблицаЗначений.Колонки.Добавить("КоличествоДней", Новый ОписаниеТипов("Число"));
	
	ПервыйОбход = Истина;
	
	Пока ДатаНачала <= ДатаОкончания Цикл
		
		Если ПервыйОбход Тогда
			
			Если КонецМесяца(ДатаНачала) >= ДатаОкончания Тогда
				НоваяСтрока = ТаблицаЗначений.Добавить();
				НоваяСтрока.ДатаНачала        = НачалоДня(ДатаНачала);
				НоваяСтрока.ДатаОкончания    = КонецДня(ДатаОкончания);
				НоваяСтрока.КоличествоДней = Окр((НоваяСтрока.ДатаОкончания - НоваяСтрока.ДатаНачала) / 86400);
				Прервать;
			Иначе
				НоваяСтрока = ТаблицаЗначений.Добавить();
				НоваяСтрока.ДатаНачала        = ДатаНачала;
				НоваяСтрока.ДатаОкончания    = КонецМесяца(ДатаНачала);
				НоваяСтрока.КоличествоДней = Окр((НоваяСтрока.ДатаОкончания - НоваяСтрока.ДатаНачала) / 86400);
			КонецЕсли;
			
		Иначе
			
			Если КонецМесяца(ДатаНачала) >= ДатаОкончания Тогда
				НоваяСтрока = ТаблицаЗначений.Добавить();
				НоваяСтрока.ДатаНачала        = НачалоМесяца(ДатаНачала);
				НоваяСтрока.ДатаОкончания    = КонецДня(ДатаОкончания);
				НоваяСтрока.КоличествоДней = Окр((НоваяСтрока.ДатаОкончания - НоваяСтрока.ДатаНачала) / 86400);
				Прервать;
			Иначе
				НоваяСтрока = ТаблицаЗначений.Добавить();
				НоваяСтрока.ДатаНачала        = НачалоМесяца(ДатаНачала);
				НоваяСтрока.ДатаОкончания    = КонецМесяца(ДатаНачала);
				НоваяСтрока.КоличествоДней = Окр((НоваяСтрока.ДатаОкончания - НоваяСтрока.ДатаНачала) / 86400);
			КонецЕсли;
			
		КонецЕсли;
		
		ДатаНачала    = КонецМесяца(ДатаНачала)+1;
		ПервыйОбход    = Ложь;    
		
	КонецЦикла;
	
	
	Возврат ТаблицаЗначений;
	
КонецФункции

#КонецОбласти

#КонецЕсли