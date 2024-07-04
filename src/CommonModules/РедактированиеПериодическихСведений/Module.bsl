////////////////////////////////////////////////////////////////////////////////
// Модуль содержит процедуры и функции работы с регистрами сведений.
//
////////////////////////////////////////////////////////////////////////////////


#Область СлужебныйПрограммныйИнтерфейс

// Чтение и запись записей периодических регистров сведений, подчиненных ведущему объекту 
// для редактирования регистров сведений в форме
//
// Параметры
//	Форма - управляемая форма
//	ИмяРегистра - имя редактируемого регистра
//	ВедущийОбъект - ссылка на ведущий объект
//
//	Требования:
//		Редактирование выполняется для регистров, где единственное измерение 
//		имееит тип "ведущего" объекта 
//		Форма должна содержать реквизиты
//			<ИмяРегистра> 				типа Менеджер записи
//			<ИмяРегистра>Прежняя 		типа Менеджер записи
//			<ИмяРегистра>НоваяЗапись 	типа булево
// см. также 
//		ИнициализироватьЗаписьДляРедактированияВФорме
//		ЗаписатьЗаписьПослеРедактированияВФорме
Процедура ПрочитатьЗаписьДляРедактированияВФорме(Форма, ИмяРегистра, ВедущийОбъект) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра];
	ИмяИзмерения = МетаданныеРегистра.Измерения[0].Имя;
	
	МенеджерЗаписи = РегистрыСведений[ИмяРегистра].СоздатьМенеджерЗаписи();
	МенеджерЗаписи[ИмяИзмерения] = ВедущийОбъект;
	
	РегистрПериодический = МетаданныеРегистра.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический;
	
	// Ищем последнюю запись
	Запрос = Новый Запрос;
	
	ПоляЗапроса = "";
	Если РегистрПериодический Тогда
		ПоляЗапроса = 
			"
			|	РегистрСведений.Период";
	КонецЕсли;
	Для каждого Измерение Из МетаданныеРегистра.Измерения Цикл
		ПоляЗапроса = ПоляЗапроса + ?(ЗначениеЗаполнено(ПоляЗапроса), ",", "") +
			"
			|	РегистрСведений." + Измерение.Имя;
	КонецЦикла;
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1" +
	ПоляЗапроса +
	"
	|ИЗ
	|	РегистрСведений." + ИмяРегистра + " КАК РегистрСведений
	|ГДЕ
	|	РегистрСведений." + ИмяИзмерения + " = &ВедущийОбъект";
	
	Если РегистрПериодический Тогда
		Запрос.Текст = 	Запрос.Текст +
		"
		|УПОРЯДОЧИТЬ ПО
		|	РегистрСведений.Период УБЫВ";
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ВедущийОбъект", ВедущийОбъект);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Прочитать();
	КонецЕсли;
	
	// имя реквизита формы совпадает с именем регистра
	Форма.ЗначениеВРеквизитФормы(МенеджерЗаписи, ИмяРегистра);
	
	ЗаписьКакСтруктура = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(МенеджерЗаписи, МетаданныеРегистра);
	Форма[ИмяРегистра + "Прежняя"] = Новый ФиксированнаяСтруктура(ЗаписьКакСтруктура);
	
	Форма[ИмяРегистра + "НоваяЗапись"] = Ложь;
	
	РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВвода(Форма, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры

// Запись записей периодических регистров сведений, подчиненных ведущему объекту 
// см. ПрочитатьЗаписьДляРедактированияВФорме
Функция ЗаписатьЗаписьПослеРедактированияВФорме(Форма, ИмяРегистра, ВедущийОбъект, ИменаКолонокИсключаемыхИзСравнения = "") Экспорт
	
	Если Форма[ИмяРегистра + "НаборЗаписейПрочитан"] Тогда
		Возврат ЗаписатьНаборЗаписейПослеРедактированияВФорме(Форма, ИмяРегистра, ВедущийОбъект, ИменаКолонокИсключаемыхИзСравнения);
	КонецЕсли;
	
	МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра];
	ИмяИзмерения = МетаданныеРегистра.Измерения[0].Имя;

	Если МетаданныеРегистра.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
		ИзменилисьДанные = Форма[ИмяРегистра].Период <> Форма[ИмяРегистра + "Прежняя"].Период;
	Иначе
		ИзменилисьДанные = Ложь;
	КонецЕсли;
	Если НЕ ИзменилисьДанные Тогда
		ИзменилисьДанные = ИзменилисьДанные ИЛИ 
		(ВедущийОбъект <> Форма[ИмяРегистра + "Прежняя"][ИмяИзмерения] И 
		ЗначениеЗаполнено(Форма[ИмяРегистра + "Прежняя"][ИмяИзмерения]));
	КонецЕсли;
	Если НЕ ИзменилисьДанные Тогда
		Для Каждого Поле Из МетаданныеРегистра.Измерения Цикл
			Если Поле.Имя = ИмяИзмерения Тогда
				Продолжить;
			КонецЕсли; 
			ИзменилисьДанные = ИзменилисьДанные ИЛИ (Форма[ИмяРегистра][Поле.Имя] <> Форма[ИмяРегистра + "Прежняя"][Поле.Имя]);
		КонецЦикла;
	КонецЕсли;
	Если НЕ ИзменилисьДанные Тогда
		Для Каждого Поле Из МетаданныеРегистра.Ресурсы Цикл
			ИзменилисьДанные = ИзменилисьДанные ИЛИ (Форма[ИмяРегистра][Поле.Имя] <> Форма[ИмяРегистра + "Прежняя"][Поле.Имя]);
		КонецЦикла;
	КонецЕсли;
	Если НЕ ИзменилисьДанные Тогда
		Для Каждого Поле Из МетаданныеРегистра.Реквизиты Цикл
			ИзменилисьДанные = ИзменилисьДанные ИЛИ (Форма[ИмяРегистра][Поле.Имя] <> Форма[ИмяРегистра + "Прежняя"][Поле.Имя]);
		КонецЦикла;
	КонецЕсли;
	
	Если ИзменилисьДанные Тогда
		// пишем новое состояние записи
		МенеджерЗаписи = Форма.РеквизитФормыВЗначение(ИмяРегистра);
		МенеджерЗаписи[ИмяИзмерения] = ВедущийОбъект;
		// если нужно сохранить старую запись, то создадим новый менеджер записи
		Если Форма[ИмяРегистра + "НоваяЗапись"] Тогда
			НоваяЗапись = РегистрыСведений[ИмяРегистра].СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(НоваяЗапись,  МенеджерЗаписи);
			НоваяЗапись.Записать();
		Иначе
			МенеджерЗаписи.Записать();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ИзменилисьДанные;
	
КонецФункции

// Инициализирует данные формы для обеспечения редактирования в ней записи 
// регистра сведений, подчиненного ведущему объекту
//
// Параметры
//	Форма - управляемая форма
//	ИмяРегистра - имя редактируемого регистра
// см. также 
//		ПрочитатьЗаписьДляРедактированияВФорме
//		ЗаписатьЗаписьПослеРедактированияВФорме
Процедура ИнициализироватьЗаписьДляРедактированияВФорме(Форма, ИмяРегистра, ВедущийОбъект) Экспорт
	МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра];
	ИмяИзмерения = МетаданныеРегистра.Измерения[0].Имя;
	МенеджерЗаписи = РегистрыСведений[ИмяРегистра].СоздатьМенеджерЗаписи();
	МенеджерЗаписи[ИмяИзмерения] = ВедущийОбъект;
	Форма.ЗначениеВРеквизитФормы(МенеджерЗаписи, ИмяРегистра);
	
	ЗаписьКакСтруктура = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(МенеджерЗаписи, МетаданныеРегистра);
	Форма[ИмяРегистра + "Прежняя"] = Новый ФиксированнаяСтруктура(ЗаписьКакСтруктура);
	
	Форма[ИмяРегистра + "НоваяЗапись"] = Ложь;
	
	РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВвода(Форма, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры

Процедура ПроверитьЗаписьВФорме(Форма, ИмяРегистра, ВедущийОбъект, Отказ) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыСведений[ИмяРегистра];
	Синоним = МетаданныеРегистра.Синоним;
	
	Если ЗначениеЗаполнено(МетаданныеРегистра.ПредставлениеЗаписи) Тогда
		Синоним = МетаданныеРегистра.ПредставлениеЗаписи;
	КонецЕсли;
	ИмяИзмерения = МетаданныеРегистра.Измерения[0].Имя;

	Если МетаданныеРегистра.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
		ИзменилисьДанные = Форма[ИмяРегистра].Период <> Форма[ИмяРегистра + "Прежняя"].Период;
	Иначе
		ИзменилисьДанные = Ложь;
	КонецЕсли;
	
	Если НЕ ИзменилисьДанные Тогда
		ИзменилисьДанные = ИзменилисьДанные ИЛИ 
		(ВедущийОбъект <> Форма[ИмяРегистра + "Прежняя"][ИмяИзмерения] И 
		ЗначениеЗаполнено(Форма[ИмяРегистра + "Прежняя"][ИмяИзмерения]));
	КонецЕсли;
	Если НЕ ИзменилисьДанные Тогда
		Для Каждого Поле Из МетаданныеРегистра.Ресурсы Цикл
			ИзменилисьДанные = ИзменилисьДанные ИЛИ (Форма[ИмяРегистра][Поле.Имя] <> Форма[ИмяРегистра + "Прежняя"][Поле.Имя]);
		КонецЦикла;
	КонецЕсли;
	Если НЕ ИзменилисьДанные Тогда
		Для Каждого Поле Из МетаданныеРегистра.Реквизиты Цикл
			ИзменилисьДанные = ИзменилисьДанные ИЛИ (Форма[ИмяРегистра][Поле.Имя] <> Форма[ИмяРегистра + "Прежняя"][Поле.Имя]);
		КонецЦикла;
	КонецЕсли;
	
	Если ИзменилисьДанные Тогда
		МенеджерЗаписи = Форма.РеквизитФормыВЗначение(ИмяРегистра);
		
		Для Каждого СтандартныйРеквизит Из МетаданныеРегистра.СтандартныеРеквизиты Цикл
			
			Если СтандартныйРеквизит.Имя = "Период" Тогда
				Если ЗначениеЗаполнено(Форма[ИмяРегистра + "Прежняя"].Период) Тогда
					Если Форма.Элементы.Найти(ИмяРегистра + "ПериодСтрокой") <> Неопределено Тогда
						ПутьКРеквизитуФормы = ИмяРегистра + "ПериодСтрокой";
					Иначе
						ПутьКРеквизитуФормы = "";
					КонецЕсли; 
					ПроверитьЗаполнениеПоляЗаписиРегистраВФорме(МенеджерЗаписи, ИмяРегистра, СтандартныйРеквизит, Синоним, Отказ, ПутьКРеквизитуФормы);
				Иначе
					Если Не РедактированиеПериодическихСведенийКлиентСервер.ЗаполненыЗначенияПоУмолчанию(Форма, ИмяРегистра, ВедущийОбъект) Тогда
						ПроверитьЗаполнениеПоляЗаписиРегистраВФорме(МенеджерЗаписи, ИмяРегистра, СтандартныйРеквизит, Синоним, Отказ);
					КонецЕсли;
				КонецЕсли;
			Иначе
				ПроверитьЗаполнениеПоляЗаписиРегистраВФорме(МенеджерЗаписи, ИмяРегистра, СтандартныйРеквизит, Синоним, Отказ);
			КонецЕсли;
		КонецЦикла;	
		
		Для Каждого Измерение Из МетаданныеРегистра.Измерения Цикл
			Если Измерение.Имя <> ИмяИзмерения Тогда
				ПроверитьЗаполнениеПоляЗаписиРегистраВФорме(МенеджерЗаписи, ИмяРегистра, Измерение, Синоним, Отказ);
			КонецЕсли;	
		КонецЦикла;

		Для Каждого Ресурс Из МетаданныеРегистра.Ресурсы Цикл
			ПроверитьЗаполнениеПоляЗаписиРегистраВФорме(МенеджерЗаписи, ИмяРегистра, Ресурс, Синоним, Отказ);
		КонецЦикла;

		Для Каждого Реквизит Из МетаданныеРегистра.Реквизиты Цикл
			ПроверитьЗаполнениеПоляЗаписиРегистраВФорме(МенеджерЗаписи, ИмяРегистра, Реквизит, Синоним, Отказ);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПрочитатьНаборЗаписей(Форма, ИмяРегистра, ВедущийОбъект) Экспорт
	
	ИмяИзмерения = Метаданные.РегистрыСведений[ИмяРегистра].Измерения[0].Имя;
	
	НаборЗаписей = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
	НаборЗаписей.Отбор[ИмяИзмерения].Установить(ВедущийОбъект);
	НаборЗаписей.Прочитать();
	
	УстановитьПривилегированныйРежим(Истина);
	
	Форма[ИмяРегистра + "НаборЗаписей"].Отбор[ИмяИзмерения].Значение = ВедущийОбъект;
	Форма[ИмяРегистра + "НаборЗаписей"].Отбор[ИмяИзмерения].Использование = Истина;
	
	Форма[ИмяРегистра + "НаборЗаписей"].Загрузить(НаборЗаписей.Выгрузить());
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Форма[ИмяРегистра + "НаборЗаписейПрочитан"] = Истина;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьЗаполнениеПоляЗаписиРегистраВФорме(МенеджерЗаписи, ИмяРегистра, ОписаниеПоля, Синоним, Отказ, ПутьКРеквизитуФормы = "")
	Если ОписаниеПоля.ПроверкаЗаполнения = ПроверкаЗаполнения.ВыдаватьОшибку И Не ЗначениеЗаполнено(МенеджерЗаписи[ОписаниеПоля.Имя]) Тогда
		ТекстНСТР = НСтр("en='%1: not filled field ""%2"".';ru='%1: не заполнено поле ""%2"".'");
		ТекстСообщения = СтрШаблон(ТекстНСТР, Синоним, ?(ЗначениеЗаполнено(ОписаниеПоля.Синоним), ОписаниеПоля.Синоним, ОписаниеПоля.Имя));
		Если ПустаяСтрока(ПутьКРеквизитуФормы) Тогда
			ПутьКРеквизитуФормы = ИмяРегистра + "." + ОписаниеПоля.Имя;
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ,	ПутьКРеквизитуФормы, , Отказ);
	КонецЕсли;		
КонецПроцедуры	

Функция ЗаписатьНаборЗаписейПослеРедактированияВФорме(Форма, ИмяРегистра, ВедущийОбъект, ИменаКолонокИсключаемыхИзСравнения = "")
	
	ИзменилисьДанные = Ложь;
	
	РедактированиеПериодическихСведенийКлиентСервер.ОбновитьНаборЗаписейИстории(Форма, ИмяРегистра, ВедущийОбъект);

	ИмяИзмерения = Метаданные.РегистрыСведений[ИмяРегистра].Измерения[0].Имя;
	
	// Подготовим к сравнению набор исходных сведений
	Набор = РегистрыСведений[ИмяРегистра].СоздатьНаборЗаписей();
	Набор.Отбор[ИмяИзмерения].Установить(ВедущийОбъект);
	Набор.Прочитать();
	ТаблицаИсходногоНабора = Набор.Выгрузить();
	
	// Подготовим к сравнению набор, хранящийся в реквизите формы
	ТаблицаНовогоНабора = Форма[ИмяРегистра + "НаборЗаписей"].Выгрузить();
	ТаблицаНовогоНабора.Колонки.Удалить("ИсходныйНомерСтроки");
	
	// Проверим необходимость записи нового набора
	Если НЕ ОбщегоНазначения.КоллекцииИдентичны(ТаблицаИсходногоНабора, ТаблицаНовогоНабора, ,ИменаКолонокИсключаемыхИзСравнения) Тогда
		
		ИзменилисьДанные = Истина;
		
		ТаблицаНовогоНабора.Сортировать("Период Убыв");
		
		Для Каждого СтрокаТаблицаНовогоНабора Из ТаблицаНовогоНабора Цикл
			
			СохранитьСтроку = Истина;
			СтрокаТаблицаИсходногоНабора = ТаблицаИсходногоНабора.Найти(СтрокаТаблицаНовогоНабора.Период, "Период");
			Если СтрокаТаблицаИсходногоНабора <> Неопределено Тогда
				Если ОбщегоНазначения.КоллекцииИдентичны(ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаТаблицаНовогоНабора), ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаТаблицаИсходногоНабора), , ИменаКолонокИсключаемыхИзСравнения) Тогда
					СохранитьСтроку = Ложь;
				КонецЕсли;
				// Удалим строку из таблицы исходного набора
				ТаблицаИсходногоНабора.Удалить(СтрокаТаблицаИсходногоНабора);
			КонецЕсли; 
			
			Если СохранитьСтроку Тогда
				НоваяЗапись = РегистрыСведений[ИмяРегистра].СоздатьМенеджерЗаписи();
				ЗаполнитьЗначенияСвойств(НоваяЗапись, СтрокаТаблицаНовогоНабора);
				НоваяЗапись.Записать();
			КонецЕсли; 
			
		КонецЦикла;
		
		Для каждого СтрокаТаблицаИсходногоНабора Из ТаблицаИсходногоНабора Цикл
			УдаляемаяЗапись = РегистрыСведений[ИмяРегистра].СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(УдаляемаяЗапись, СтрокаТаблицаИсходногоНабора);
			УдаляемаяЗапись.Удалить();
		КонецЦикла;
		
	КонецЕсли; 
	
	Возврат ИзменилисьДанные;
	
КонецФункции

#КонецОбласти
