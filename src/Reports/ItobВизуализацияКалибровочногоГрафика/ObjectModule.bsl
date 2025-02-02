#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. процедуру ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию.
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//  
//  См. также:
//  "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
// Параметры:
//  Форма				 - УправляемаяФорма	 - Форма отчета.
//  Отказ				 - Булево			 - Передается из параметров обработчика "как есть".
//  СтандартнаяОбработка - Булево			 - Передается из параметров обработчика "как есть".
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	// Кешируем параметры формы.
	ПараметрыФормы = ItobОтчетыКлиентСерверПовтИсп.ПараметрыФормы(Строка(Форма.УникальныйИдентификатор));
	ПараметрыФормы.Очистить();
	Если Форма.Параметры.Свойство("СписокПараметров") Тогда
		ПараметрыФормы.Вставить("СписокПараметров", Форма.Параметры.СписокПараметров);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после перезаполнения панели настроек формы отчета.
//
// Параметры:
//  Форма				 - УправляемаяФорма	 - Форма отчета.
//  ПервоеОткрытиеФормы	 - Булево - Признак первого открытия формы
//
Процедура ИзменитьФормуПослеСозданияЭлементовНастроек(Форма, ПервоеОткрытиеФормы) Экспорт
	
	// Проверяем, открывается ли нужная форма.
	Если НЕ Форма.ТипФормыОтчета = ТипФормыОтчета.Основная 
		 ИЛИ НЕ СтрНайти(Форма.ИмяФормы, "ФормаНастроек") = 0 Тогда // Если используется общая форма из БСП проверяем на имя.
		 
		Возврат;
	КонецЕсли;
	
	Если НЕ ПервоеОткрытиеФормы Тогда
		
		Возврат;		
	КонецЕсли;
	
	// Получаем из кеша параметры формы.
	ПараметрыФормы = ItobОтчетыКлиентСерверПовтИсп.ПараметрыФормы(Строка(Форма.УникальныйИдентификатор));
	
	Если ПараметрыФормы.Количество() > 0 Тогда
		ПараметрыДанных = ItobОтчетыКлиентСервер.ПолучитьПараметрыДанных(Форма);	
		Для каждого Параметр Из ПараметрыФормы.СписокПараметров Цикл
		    Если Параметр.Представление = "КалибровочныйГрафик" Тогда
				ItobОтчетыКлиентСервер.УстановитьЗначениеПараметра(ПараметрыДанных, 
																   "КалибровочныйГрафик", 
																   Параметр.Значение, 
																   НСтр("ru = 'Калибровочный график'; en = 'Calibration chart'"));
		   	КонецЕсли; 
		КонецЦикла;		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти  

#КонецЕсли
